param (
    [string]$path_to_project_json,
    [string]$suffix
)

Import-Module $PSScriptRoot/shared_components.psm1 -Force
#Reads project.json, appends the contents of $suffix onto the project name, and then writes the data back to file
$jsonObject = Read-UiPathProjectFile -path $path_to_project_json
$jsonObject.name = "$($jsonObject.name)$($suffix)"
Write-UiPathProjectFile -path $path_to_project_json -data $jsonObject