param([string]$ProjectRoot,[switch]$OverwriteAgentsMd,[switch]$KeepSource,[switch]$Force)
& (Join-Path $PSScriptRoot "Install-Project.ps1") -ProjectRoot $ProjectRoot -Runtime OpenCode -OverwriteAgentsMd:$OverwriteAgentsMd -KeepSource:$KeepSource -Force:$Force
