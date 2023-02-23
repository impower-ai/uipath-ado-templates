param (
    #Expected to be root directory of project with no trailing path seperators
    [string]$path_to_project,
    #Comma seperated tags - ex. '@smoke, @FEAT6321'
    [string]$tags,
    #If true, set matching tests to publishable even if they are currently hidden
    [switch]$auto_enable = $false
)

Import-Module $PSScriptRoot/shared_components.psm1 -Force

Write-Host "Auto Enable - $auto_enable"
Write-Host "Path To Project - $path_to_project"
Write-Host "Tags - $tags"
if($auto_enable){
    Write-Host "Disabling Untagged Tests AND Enabling Tagged Tests..."
}else{
    Write-Host "Disabling Untagged Tests..."
}

#Modify project.json
$jsonObject = Read-UiPathProjectFile -path $path_to_project

#Iterate over test files
foreach ($file in $jsonObject."designOptions"."fileInfoCollection")
{

    $match_found = $false
    $fileName = $file."fileName"
    Write-Host "Reading file $fileName..."
    $fileContents = Get-Content "$path_to_project\\$fileName"
    foreach($tag in $tags.Split(",")){
        $escapedTag = [Regex]::Escape($tag)

        #Check if input file has a "Comment" Activity containing tag text in the text field
        if($fileContents -Match "<+.*Comment.*Text=`".*$($escapedTag).*\`".*\/>"){
            $match_found = $true    
            Write-Host "Tag Found - $tag"
            break
        }
    }


    if($match_found -And $auto_enable){
        $file."editingStatus" = "Publishable"
    }elseif(-Not $match_found){
        $file."editingStatus" = "InProgress"
    }
}

Write-Host "Writing Modified Project Configuration To Disk.."
Read-UiPathProjectFile -path $path_to_project -data $jsonObject