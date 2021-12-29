param(
    [string] $search_phrase
)

#Get Most Recent Commit Message
$phrase_found = "false"
$commit_message = git log -1 --no-merges --pretty=%B

Write-Host "Most Recent Commit Message- $commit_message"
Write-Host "Search Phrase - $search_phrase"

$escaped_search_phrase = $search_phrase -replace "\]","\]" -replace "\[","\["
Write-Host "Escaped Search Phrase - $escaped_search_phrase"

if("$commit_message" -Match "$escaped_search_phrase"){
    $phrase_found = "true"    
}

Write-Host "Search Phrase Found? - $phrase_found"
Write-Host "##vso[task.setvariable variable=phraseFound;isOutput=true]$phrase_found"