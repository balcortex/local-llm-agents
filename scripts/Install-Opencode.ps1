param(
    [string]$ProjectRoot,

    [switch]$OverwriteAgentsMd,

    [switch]$KeepSource
)

$ErrorActionPreference = "Stop"

function Write-Section {
    param([string]$Message)

    Write-Host ""
    Write-Host "== $Message =="
}

function Resolve-FullPath {
    param([string]$Path)

    return (Resolve-Path $Path).Path
}

# Expected layout when installing:
# project/
# └── local-llm-agents/
#     └── scripts/
#         └── Install-Opencode.ps1

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$SourceRoot = Split-Path -Parent $ScriptDir

# If ProjectRoot is not provided:
# - If the user runs from the project root, use current directory.
# - If the user runs from inside local-llm-agents, use the parent of local-llm-agents.
if ([string]::IsNullOrWhiteSpace($ProjectRoot)) {
    $CurrentDir = (Get-Location).Path
    $ResolvedCurrentDir = Resolve-FullPath $CurrentDir
    $ResolvedSourceRoot = Resolve-FullPath $SourceRoot

    if ($ResolvedCurrentDir.StartsWith($ResolvedSourceRoot, [System.StringComparison]::OrdinalIgnoreCase)) {
        $ProjectRoot = Split-Path -Parent $ResolvedSourceRoot
    }
    else {
        $ProjectRoot = $ResolvedCurrentDir
    }
}

$ProjectRoot = Resolve-FullPath $ProjectRoot
$SourceRoot = Resolve-FullPath $SourceRoot

$SourceAgents = Join-Path $SourceRoot "agents"
$SourceSkills = Join-Path $SourceRoot "skills"
$SourceAgentsMd = Join-Path $SourceRoot "AGENTS.md"

$TargetOpenCode = Join-Path $ProjectRoot ".opencode"
$TargetAgents = Join-Path $TargetOpenCode "agents"
$TargetSkills = Join-Path $TargetOpenCode "skills"
$TargetAgentsMd = Join-Path $ProjectRoot "AGENTS.md"

Write-Section "Installing local LLM agents for opencode"
Write-Host "Source: $SourceRoot"
Write-Host "Target: $ProjectRoot"

# Safety checks
if (-not (Test-Path $SourceAgents)) {
    throw "Missing source agents folder: $SourceAgents"
}

if (-not (Test-Path $SourceSkills)) {
    throw "Missing source skills folder: $SourceSkills"
}

if (-not (Test-Path $SourceAgentsMd)) {
    throw "Missing source AGENTS.md: $SourceAgentsMd"
}

if ($SourceRoot -eq $ProjectRoot) {
    throw "SourceRoot and ProjectRoot are the same. Refusing to install into the source repository itself. Copy or clone this repo inside the target project first."
}

# Create target folders
Write-Section "Creating opencode folders"

New-Item -ItemType Directory -Path $TargetAgents -Force | Out-Null
New-Item -ItemType Directory -Path $TargetSkills -Force | Out-Null

Write-Host "Created: $TargetAgents"
Write-Host "Created: $TargetSkills"

# Copy agents
Write-Section "Copying agents"

Copy-Item -Path (Join-Path $SourceAgents "*.md") -Destination $TargetAgents -Force

Get-ChildItem $TargetAgents -Filter "*.md" | Sort-Object Name | ForEach-Object {
    Write-Host " - $($_.Name)"
}

# Copy skills
Write-Section "Copying skills"

Copy-Item -Path (Join-Path $SourceSkills "*") -Destination $TargetSkills -Recurse -Force

Get-ChildItem $TargetSkills -Directory | Sort-Object Name | ForEach-Object {
    Write-Host " - $($_.Name)"
}

# Copy AGENTS.md
Write-Section "Installing AGENTS.md"

if (Test-Path $TargetAgentsMd) {
    if ($OverwriteAgentsMd) {
        Copy-Item -Path $SourceAgentsMd -Destination $TargetAgentsMd -Force
        Write-Host "Updated existing AGENTS.md"
    }
    else {
        Write-Host "Skipped AGENTS.md because it already exists."
        Write-Host "Use -OverwriteAgentsMd to replace it."
    }
}
else {
    Copy-Item -Path $SourceAgentsMd -Destination $TargetAgentsMd -Force
    Write-Host "Created AGENTS.md"
}

# Cleanup source folder by default unless -KeepSource is used
Write-Section "Cleanup"

if ($KeepSource) {
    Write-Host "Keeping source folder because -KeepSource was used."
}
else {
    $sourceInsideProject = $SourceRoot.StartsWith($ProjectRoot, [System.StringComparison]::OrdinalIgnoreCase)

    if ($sourceInsideProject -and ($SourceRoot -ne $ProjectRoot)) {
        Write-Host "Removing temporary source folder:"
        Write-Host $SourceRoot

        Remove-Item -Path $SourceRoot -Recurse -Force

        Write-Host "Removed temporary source folder."
    }
    else {
        Write-Host "Cleanup skipped for safety."
        Write-Host "The source folder is not inside the target project, or it is the project root itself."
    }
}

Write-Section "Done"

Write-Host "opencode agents installed successfully."
Write-Host ""
Write-Host "Installed structure:"
Write-Host " - .opencode/agents/"
Write-Host " - .opencode/skills/"
Write-Host " - AGENTS.md"
Write-Host ""
Write-Host "Restart opencode UI and open:"
Write-Host $ProjectRoot
