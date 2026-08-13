param(
    [string]$ProjectRoot,
    [ValidateSet("Codex","OpenCode","Both")][string]$Runtime = "Codex",
    [switch]$OverwriteAgentsMd,
    [switch]$KeepSource,
    [switch]$Force,
    [switch]$SkipInitialize
)
. (Join-Path $PSScriptRoot "Common.ps1")
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$SourceRoot = Split-Path -Parent $ScriptDir
if ([string]::IsNullOrWhiteSpace($ProjectRoot)) {
    $current = Get-FullPath "."
    $source = Get-FullPath $SourceRoot
    if ($current.StartsWith($source,[StringComparison]::OrdinalIgnoreCase)) { $ProjectRoot = Split-Path -Parent $source } else { $ProjectRoot = $current }
}
$ProjectRoot = Get-FullPath $ProjectRoot
$SourceRoot = Get-FullPath $SourceRoot
if ($ProjectRoot -eq $SourceRoot) { throw "Refusing to install the source repository into itself." }

$AgentDir = Join-Path $ProjectRoot ".agent"
$HarnessDir = Join-Path $AgentDir "harness"
Ensure-Directory $AgentDir; Ensure-Directory $HarnessDir; Ensure-Directory (Join-Path $AgentDir "runs"); Ensure-Directory (Join-Path $AgentDir "candidates")
$ManifestPath = Join-Path $AgentDir "manifest.json"
$oldManifest = Read-JsonFile $ManifestPath
$oldFiles = @{}
if ($oldManifest -and $oldManifest.files) { foreach($prop in $oldManifest.files.PSObject.Properties){ $oldFiles[$prop.Name]=$prop.Value } }
$newFiles = @{}

function Install-ManagedFile([string]$Source,[string]$RelativeTarget,[switch]$AllowExisting) {
    $target = Join-Path $ProjectRoot $RelativeTarget
    Ensure-Directory (Split-Path -Parent $target)
    if (Test-Path $target) {
        if ($AllowExisting -and -not $Force) { Write-Host "SKIP existing: $RelativeTarget"; return }
        if ($oldFiles.ContainsKey($RelativeTarget) -and -not $Force) {
            $currentHash = Get-Sha256 $target
            if ($currentHash -ne [string]$oldFiles[$RelativeTarget]) {
                Write-Warning "Local drift detected; not overwriting: $RelativeTarget (use -Force)"
                $newFiles[$RelativeTarget] = [string]$oldFiles[$RelativeTarget]
                return
            }
        }
    }
    Copy-Item -LiteralPath $Source -Destination $target -Force
    $newFiles[$RelativeTarget] = Get-Sha256 $target
    Write-Host "INSTALL: $RelativeTarget"
}

foreach($name in @("Common.ps1","Agent-Check.ps1","Agent-Status.ps1")) {
    Install-ManagedFile (Join-Path $SourceRoot "scripts/$name") ".agent/harness/$name"
}
Install-ManagedFile (Join-Path $SourceRoot "schemas/review-result.schema.json") ".agent/schemas/review-result.schema.json"

$targetAgentsMd = Join-Path $ProjectRoot "AGENTS.md"
if (-not (Test-Path $targetAgentsMd) -or $OverwriteAgentsMd) {
    Install-ManagedFile (Join-Path $SourceRoot "AGENTS.md") "AGENTS.md"
} else {
    Write-Host "SKIP existing AGENTS.md (use -OverwriteAgentsMd or merge the V2 contract manually)."
    Copy-Item (Join-Path $SourceRoot "AGENTS.md") (Join-Path $AgentDir "AGENTS.local-llm-agents.md") -Force
}

if ($Runtime -in @("Codex","Both")) {
    Ensure-Directory (Join-Path $ProjectRoot ".agents/skills")
    Get-ChildItem (Join-Path $SourceRoot "skills") -Directory | ForEach-Object {
        $skillFile = Join-Path $_.FullName "SKILL.md"
        if (Test-Path $skillFile) { Install-ManagedFile $skillFile (".agents/skills/"+$_.Name+"/SKILL.md") }
    }
}

if ($Runtime -in @("OpenCode","Both")) {
    $oc = Join-Path $ProjectRoot ".opencode"
    Ensure-Directory (Join-Path $oc "agents"); Ensure-Directory (Join-Path $oc "skills")
    Get-ChildItem (Join-Path $SourceRoot "agents") -Filter "*.md" | ForEach-Object { Install-ManagedFile $_.FullName (".opencode/agents/"+$_.Name) }
    Get-ChildItem (Join-Path $SourceRoot "skills") -Directory | ForEach-Object {
        $skillFile = Join-Path $_.FullName "SKILL.md"
        if (Test-Path $skillFile) { Install-ManagedFile $skillFile (".opencode/skills/"+$_.Name+"/SKILL.md") }
    }
}

if (-not $SkipInitialize) {
    & (Join-Path $SourceRoot "scripts/Initialize-AgentProject.ps1") -ProjectRoot $ProjectRoot
}
Add-GitIgnoreEntry $ProjectRoot ".agent/runs/"
Add-GitIgnoreEntry $ProjectRoot ".agent/eval-results/"

$manifest = [ordered]@{
    schema_version=1; source="balcortex/local-llm-agents"; version=(Get-SourceVersion $SourceRoot); commit=(Get-SourceCommit $SourceRoot);
    runtime=$Runtime; installed_at=(Get-Date).ToString('o'); files=$newFiles
}
foreach($k in $oldFiles.Keys){ if (-not $manifest.files.Contains($k)) { $manifest.files[$k]=$oldFiles[$k] } }
Write-JsonFile $ManifestPath $manifest
Write-Host "Installed local-llm-agents $($manifest.version) for $Runtime into $ProjectRoot"

if (-not $KeepSource) {
    $inside = $SourceRoot.StartsWith($ProjectRoot,[StringComparison]::OrdinalIgnoreCase)
    if ($inside -and $SourceRoot -ne $ProjectRoot) {
        Write-Host "Removing temporary source folder: $SourceRoot"
        $cmd = "Start-Sleep -Milliseconds 250; Remove-Item -LiteralPath '" + $SourceRoot.Replace("'","''") + "' -Recurse -Force"
        Start-Process powershell -WindowStyle Hidden -ArgumentList @('-NoProfile','-Command',$cmd) | Out-Null
    }
}
