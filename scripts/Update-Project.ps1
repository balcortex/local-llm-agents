param(
    [Parameter(Mandatory=$true)][string]$TargetProject,
    [ValidateSet("Codex","OpenCode","Both")][string]$Runtime,
    [switch]$Force,
    [switch]$OverwriteAgentsMd
)
. (Join-Path $PSScriptRoot "Common.ps1")
$TargetProject = Get-FullPath $TargetProject
$manifest = Read-JsonFile (Join-Path $TargetProject ".agent/manifest.json")
if (-not $Runtime) {
    if ($manifest -and $manifest.runtime) { $Runtime=[string]$manifest.runtime } else { $Runtime="Codex" }
}
& (Join-Path $PSScriptRoot "Install-Project.ps1") -ProjectRoot $TargetProject -Runtime $Runtime -KeepSource -Force:$Force -OverwriteAgentsMd:$OverwriteAgentsMd
