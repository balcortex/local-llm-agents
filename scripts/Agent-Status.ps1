param([string]$ProjectRoot = ".")
. (Join-Path $PSScriptRoot "Common.ps1")
$ProjectRoot = Get-FullPath $ProjectRoot
$config = Read-JsonFile (Join-Path $ProjectRoot ".agent/project.json")
$state = Read-JsonFile (Join-Path $ProjectRoot ".agent/runs/validation-state.json")
$manifest = Read-JsonFile (Join-Path $ProjectRoot ".agent/manifest.json")
Write-Host "Project: $ProjectRoot"
if ($manifest) {
    Write-Host "Installed local-llm-agents: $($manifest.version)"
    Write-Host "Source commit: $($manifest.commit)"
    Write-Host "Runtime: $($manifest.runtime)"
} else { Write-Host "Manifest: not installed" }
if ($config) {
    Write-Host "Max validation attempts: $($config.max_validation_attempts)"
    Write-Host "Checks:"
    @($config.checks) | ForEach-Object { Write-Host " - $($_.name): $($_.command) required=$($_.required)" }
} else { Write-Host "Checks: not configured" }
if ($state) { Write-Host "Last validation: $($state.last_status), attempt $($state.attempt)" } else { Write-Host "Last validation: none" }
