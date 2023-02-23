param (
    #Path to the project.json you would like to update
    [string]$path_to_project_json,
    #Any publicly accessible image url
    [string]$image_url,
    #If true, will override any existing package URL
    [bool]$override = $true
)

Import-Module $PSScriptRoot/shared_components.psm1 -Force

#Convert project.json to object
$jsonObject = Read-UiPathProjectFile -path $path_to_project_json

#Checks to see if the top-level 'publishData' JSON property exists
$publishDataExists = [bool]($jsonObject.PSobject.Properties.name -match "publishData");
if(-Not $publishDataExists){
    #If the 'publishData' property doesn't exist, construct a new one and insert it into the JSON object
    $iconObject = [pscustomobject]@{
        'iconUrl'=$image_url
    }
    $jsonObject | Add-Member "publishData" $iconObject
}else{
    #If the 'publishData' property DOES exist, check to see if the child 'iconUrl' parameter exists
    $iconUrlExists = [bool]($jsonObject.publishData.PSobject.Properties.name -match "iconUrl");
    if(-Not $iconUrlExists){
        #If 'publishData'.'iconUrl' does not exist, add it
        $jsonObject.publishData | Add-Member "iconUrl" $image_url
    }elseif($override){
        #Override the existing URL, if configured to do so.
        $jsonObject.publishData.iconUrl = $image_url
    }
}
#Write the data back to the project.json
Write-UiPathProjectFile -path $path_to_project_json -data $jsonObject