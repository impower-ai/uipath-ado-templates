param (
    #Path to project.json
    [string]$path,
    #Build number = will be used as patch version
    [string]$build_number,
)

$jsonObject = Get-Content "$($path)" -raw | ConvertFrom-Json
$major,$minor,$patch =  $jsonObject.projectVersion.split('.')
$calculated_version = "$($major).$($minor).$($patch).$($build_number)"
Write-Host "Calcuated Version - $calculated_version"
#Output to Azure Devops output variable
Write-Host "##vso[task.setvariable variable=calculated_version; isOutput=true]$calculated_version"
