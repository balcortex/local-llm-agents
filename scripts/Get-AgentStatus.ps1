param([Parameter(Mandatory=$true)][string]$TargetProject)
. (Join-Path $PSScriptRoot "Common.ps1")
$SourceRoot = Split-Path -Parent $PSScriptRoot
$TargetProject = Get-FullPath $TargetProject
$manifest = Read-JsonFile (Join-Path $TargetProject ".agent/manifest.json")
if (-not $manifest) { Write-Host "NOT INSTALLED"; exit 2 }
$sourceVersion = Get-SourceVersion $SourceRoot
$sourceCommit = Get-SourceCommit $SourceRoot
Write-Host "Project: $TargetProject"
Write-Host "Installed version: $($manifest.version)"
Write-Host "Installed commit: $($manifest.commit)"
Write-Host "Source version: $sourceVersion"
Write-Host "Source commit: $sourceCommit"
$drift=@()
foreach($prop in $manifest.files.PSObject.Properties){
    $path=Join-Path $TargetProject $prop.Name
    if (-not (Test-Path $path)) { $drift += "$($prop.Name) [missing]"; continue }
    if ((Get-Sha256 $path) -ne [string]$prop.Value) { $drift += "$($prop.Name) [modified]" }
}
if ($drift.Count) { Write-Host "Local drift:"; $drift|ForEach-Object{Write-Host " - $_"} } else { Write-Host "Local drift: none" }
if ($manifest.version -ne $sourceVersion -or ($sourceCommit -ne 'unknown' -and $manifest.commit -ne $sourceCommit)) { Write-Host "Status: UPDATE AVAILABLE" } else { Write-Host "Status: CURRENT" }
