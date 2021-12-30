param(
    [string] $search_phrases,
    [switch] $find_value = $false
)
$phrase_found = $false
$flag_value = "null"
$commit_message = git log -1 --no-merges --pretty=%B

Write-Host "Searching For Value? - $find_value"
Write-Host "Most Recent Commit Message- $commit_message"

$search_phrases.Split(",") | ForEach{
    $flag = $_.Trim()
    Write-Host "Search Flag - $flag"
    if($find_value){
        $search_phrase = "\[$flag\s?=\s?\'(.*?)\'\]"
        Write-Host "Flag Regex - $search_phrase"
        if("$commit_message" -Match "$search_phrase"){
            $phrase_found = $true
            $flag_value = $Matches[1].Trim()
        }
    }
    else
    {
        $search_phrase = "\[$flag\]"
        Write-Host "Flag Regex - $search_phrase"
        if("$commit_message" -Match "$search_phrase"){
            $phrase_found = $true   
        }
    }

}

Write-Host "Search Flag(s) Found? - $phrase_found"
Write-Host "##vso[task.setvariable variable=phraseFound;isOutput=true]$phrase_found"
if($find_value -And $phrase_found){
    Write-Host "Flag Value - $flag_value"
    Write-Host "##vso[task.setvariable variable=flagValue;isOutput=true]$flag_value"  
}
