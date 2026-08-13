param(
    [Parameter(Mandatory=$true)][string]$SourceProject,
    [Parameter(Mandatory=$true)][string]$RelativePath,
    [string]$Reason = "project evidence",
    [string]$Name
)
. (Join-Path $PSScriptRoot "Common.ps1")
$RepoRoot = Split-Path -Parent $PSScriptRoot
$SourceProject = Get-FullPath $SourceProject
$source = Join-Path $SourceProject $RelativePath
if (-not (Test-Path $source -PathType Leaf)) { throw "Candidate source not found: $source" }
if (-not $Name) { $Name = ([IO.Path]::GetFileNameWithoutExtension($source)) }
$stamp=Get-Date -Format 'yyyyMMdd-HHmmss'
$destDir=Join-Path $RepoRoot "candidates/$Name/$stamp"
Ensure-Directory $destDir
Copy-Item $source (Join-Path $destDir ([IO.Path]::GetFileName($source)))
$meta=[ordered]@{source_project=$SourceProject; relative_path=$RelativePath; reason=$Reason; created_at=(Get-Date).ToString('o')}
Write-JsonFile (Join-Path $destDir 'candidate.json') $meta
Write-Host "Candidate exported: $destDir"
