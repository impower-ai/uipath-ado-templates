function Read-UiPathProjectFile{
    param (
        [string] $path
    )
    Write-Host "Reading file... " + $path
    $path = Find-UiPathProjectFile -path $path
    return Get-Content "$($path)" -raw | ConvertFrom-Json

}
function Find-UiPathProjectFile{
    param (
        [string] $path
    )
    Write-Host "Finding project file for '$($path)'"
    if($path.EndsWith('project.json') -And (Test-Path -Path $path -PathType Leaf)){
        return $path 
    }
    elseif (Test-Path -Path $path -PathType Container) {
        $path = Join-Path -Path $path -ChildPath "project.json"
        if(Test-Path $path -PathType Leaf){
            return $path
        }
    }
}

function Write-UiPathProjectFile{
    param (
        [string] $path,
        [object] $data
    )
    $path = Find-UiPathProjectFile($path)
    $data | ConvertTo-Json -depth 32| Set-Content "$($path)"
}