param(
    [Parameter(Mandatory=$true,Position=0)][string]$Task,
    [string]$ProjectRoot = ".",
    [string]$Model,
    [switch]$SkipReview
)
. (Join-Path $PSScriptRoot "Common.ps1")
$ProjectRoot=Get-FullPath $ProjectRoot
$codex=Get-Command codex -ErrorAction Stop
$check=Join-Path $ProjectRoot '.agent/harness/Agent-Check.ps1'
if (-not (Test-Path $check)) { throw "Harness not installed. Run Install-Codex.ps1 first." }

$prompt=@"
Complete this task in the current repository:
$Task

Follow AGENTS.md. Use .agent/harness/Agent-Check.ps1 as the deterministic validation source. Do not bypass required checks.
"@
$args=@('exec','--cd',$ProjectRoot)
if ($Model){$args+=@('--model',$Model)}
$args+=$prompt
& $codex.Source @args
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }
& $check -ProjectRoot $ProjectRoot
if ($LASTEXITCODE -ne 0) { Write-Host "Validation did not pass. The agent-driven interactive workflow is recommended for corrective iterations."; exit $LASTEXITCODE }
if (-not $SkipReview) { Write-Host "Validation PASS. Review the diff in Codex or OpenCode before merging." }
