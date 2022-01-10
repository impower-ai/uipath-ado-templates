param (
    #Directory of files that need renamed
    [string]$directory_path,
    #Suffix to be applied to files
    [string]$suffix,
    #Filter for determining which files to append suffix
    [string]$filter = "*.nupkg"
)

Get-ChildItem -Path $directory_path -Filter "$($filter)" | ForEach-Object {
  Rename-Item -Path $_.FullName -NewName ($_.Basename + $suffix + $_.extension) -Verbose
}
