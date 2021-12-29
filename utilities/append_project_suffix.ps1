param (
    [string]$path_to_project_json,
    [string]$suffix
)

#Reads project.json, appends the contents of $suffix onto the project name, and then writes the data back to file
$jsonObject = Get-Content "$($path_to_project_json)" -raw | ConvertFrom-Json
$jsonObject.name = "$($jsonObject.name)$($suffix)"
$jsonObject | ConvertTo-Json -depth 32 | Set-Content "$($path_to_project_json)"