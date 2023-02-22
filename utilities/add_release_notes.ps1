param (
    #Path to the folder containing your project.json
    [string]$path_to_project_folder
)

#Read the project.json
$path_to_project_json = $path_to_project_folder + "\project.json"
$jsonObject = Get-Content "$($path_to_project_json)" -raw | ConvertFrom-Json

#Remember current context, and then change directory to the project
$current_context = Get-Location
Set-Location -Path $path_to_project_folder

#Append [RELEASE NOTES] and most recent commit to project description
$jsonObject.description += "`n`<< RELEASE NOTES >>"
$recentCommits = git log -5 --no-merges --oneline --pretty="tformat:|%as - %s"
$recentCommits = $recentCommits.Replace("|","`n`r")
$jsonObject.description += $recentCommits
Write-Host $recentCommits

#Reset context and write data to project.json
Set-Location -Path $current_context
$jsonObject | ConvertTo-Json -depth 32| Set-Content "$($path_to_project_json)"
