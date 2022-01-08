param (
    #Directory of files that need renamed
    [string]$directory_path,
    #Suffix to be applied to files
    [string]$suffix = "-alpha"
)
Get-ChildItem -Path $directory_path -Filter "*.nupkg" | ForEach-Object {
  $temp_id = (New-Guid).ToString().Substring(0,8)
  $package_path = $_.FullName
  $unzipped_folder = $_.DirectoryName + "/" + $temp_id
  $zipped_path = $package_path + ".zip"

  #Unzip Nupkg To 
  Rename-Item $package_path $zipped_path
  Expand-Archive -Path $zipped_path -DestinationPath $unzipped_folder -Force
  $nuspec_path = $unzipped_folder + "/" + @(Get-ChildItem -Path $unzipped_folder -Filter "*.nuspec")[0]
  [xml]$nuspec_content = Get-Content $nuspec_path
  $nuspec_content.package.metadata.version = $nuspec_content.package.metadata.version + $suffix
  $nuspec_content.Save($nuspec_path)
  Compress-Archive -Path ($unzipped_folder+"/*") -DestinationPath $zipped_path -Force
  Rename-Item -Path $zipped_path -NewName $package_path -Verbose
  Remove-Item -Path $unzipped_folder -Recurse
}