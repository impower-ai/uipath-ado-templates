param (
    #Nupkg's that need metadata added
    [string]$package_directory,
    #Directory of repository where target metadata exists
    [string]$repo_directory,
    #Pattern to filter nuget packages
    [string]$search_pattern = "*.nupkg",
    #Suffix to be applied to files
    [bool]$is_alpha = $false
)

Write-Host "Writing Metadata for Repository at $($repo_directory)"
Push-Location -Path $repo_directory

#Get Authors From 
$authors =  git log --pretty="%ae" | sort | Sort-Object -unique
$authors = $authors -join ","
Write-Host "Authors: $authors"

$release_notes = git log -5 --no-merges --pretty=format:"[%ar -  %s]"
Write-Host "Release Notes: $release_notes" 

Pop-Location

Get-ChildItem -Path $package_directory -Filter $search_pattern | ForEach-Object {
  $temp_id = (New-Guid).ToString().Substring(0,8)
  $package_path = $_.FullName
  $unzipped_folder = $_.DirectoryName + "/" + $temp_id
  $zipped_path = $package_path + ".zip"

  #Unzip .nupkg to temporary directory
  Rename-Item $package_path $zipped_path
  Expand-Archive -Path $zipped_path -DestinationPath $unzipped_folder -Force
  $nuspec_path = $unzipped_folder + "/" + @(Get-ChildItem -Path $unzipped_folder -Filter "*.nuspec")[0]
  [xml]$nuspec_content = Get-Content $nuspec_path

  #Mark as Alpha
  if($is_alpha){
    $nuspec_content.package.metadata.version = $nuspec_content.package.metadata.version + "-alpha"
  }
  $nuspec_content.package.metadata.authors = $authors

  #Create Release Notes
  $release_notes_content = $release_notes -Join "`n`r"
  $release_notes_node = $nuspec_content.CreateElement("releaseNotes")
  $release_notes_text = $nuspec_content.CreateTextNode($release_notes_content)
  $output = $release_notes_node.AppendChild($release_notes_text)
  $output = $nuspec_content.package.metadata.AppendChild($release_notes_node)

  #Package readme, if it exists
  if(Test-Path -Path "$repo_directory/readme.md" -PathType Leaf){
    Copy-Item -Path "$repo_directory/readme.md" -Destination "$unzipped_folder/readme.md"
    $readme_node = $nuspec_content.CreateElement("readme")
    $readme_text = $nuspec_content.CreateTextNode("readme.md")
    $output = $readme_node.AppendChild($readme_text)
    $output = $nuspec_content.package.metadata.AppendChild($readme_node)

  }

  #Save .nuspec and re-zip
  $nuspec_content.Save($nuspec_path)
  Compress-Archive -Path ($unzipped_folder+"/*") -DestinationPath $zipped_path -Force
  Rename-Item -Path $zipped_path -NewName $package_path
  Remove-Item -Path $unzipped_folder -Recurse
}