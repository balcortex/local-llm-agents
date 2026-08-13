param(
    [string]$ProjectRoot = ".",
    [switch]$ResetAttempts,
    [switch]$NoAttemptLimit
)
. (Join-Path $PSScriptRoot "Common.ps1")
$ProjectRoot = Get-FullPath $ProjectRoot
$AgentDir = Join-Path $ProjectRoot ".agent"
$ConfigPath = Join-Path $AgentDir "project.json"
$RunsDir = Join-Path $AgentDir "runs"
$StatePath = Join-Path $RunsDir "validation-state.json"
Ensure-Directory $RunsDir

if (-not (Test-Path $ConfigPath)) {
    Write-Host "HARNESS_RESULT: BLOCKED"
    Write-Host "reason: missing .agent/project.json"
    exit 2
}
$config = Read-JsonFile $ConfigPath
$maxAttempts = [int]$config.max_validation_attempts
if ($maxAttempts -lt 1) { $maxAttempts = 1 }

if ($ResetAttempts -and (Test-Path $StatePath)) { Remove-Item $StatePath -Force }
$state = Read-JsonFile $StatePath
$attempt = 1
if ($state -and $state.attempt -and $state.last_status -ne "PASS") { $attempt = [int]$state.attempt + 1 }
if (-not $NoAttemptLimit -and $attempt -gt $maxAttempts) {
    Write-Host "HARNESS_RESULT: LIMIT_REACHED"
    Write-Host "attempts: $($attempt - 1)/$maxAttempts"
    Write-Host "action: stop and report the remaining failure/blocker"
    exit 3
}

$timestamp = Get-Date -Format "yyyyMMdd-HHmmss"
$runDir = Join-Path $RunsDir ("validation-{0}-attempt-{1}" -f $timestamp,$attempt)
Ensure-Directory $runDir
$results = @()
$overall = "PASS"

Push-Location $ProjectRoot
try {
    foreach ($check in @($config.checks)) {
        $name = [string]$check.name
        $command = [string]$check.command
        $required = [bool]$check.required
        $timeout = 600
        if ($check.timeout_seconds) { $timeout = [int]$check.timeout_seconds }
        $outFile = Join-Path $runDir ("{0}.log" -f ($name -replace '[^A-Za-z0-9_.-]','_'))
        Write-Host "CHECK: $name"
        Write-Host "COMMAND: $command"
        $sw = [Diagnostics.Stopwatch]::StartNew()
        try {
            $job = Start-Job -ScriptBlock {
                param($cwd,$cmd)
                Set-Location $cwd
                $ErrorActionPreference = "Continue"
                Invoke-Expression $cmd 2>&1
                $code = $LASTEXITCODE
                if ($null -eq $code) { $code = if ($?) { 0 } else { 1 } }
                Write-Output "__HARNESS_EXIT_CODE__=$code"
                exit 0
            } -ArgumentList $ProjectRoot,$command
            if (-not (Wait-Job $job -Timeout $timeout)) {
                Stop-Job $job -ErrorAction SilentlyContinue
                $output = "Timed out after $timeout seconds"
                $exitCode = 124
            } else {
                $output = (Receive-Job $job -ErrorAction SilentlyContinue | Out-String)
                $exitCode = 0
                if ($job.State -ne 'Completed') { $exitCode = 1 }
                if ($output -match '(?m)^__HARNESS_EXIT_CODE__=(\d+)\s*$') { $exitCode = [int]$Matches[1]; $output = $output -replace '(?m)^__HARNESS_EXIT_CODE__=\d+\s*$','' }
            }
            Remove-Job $job -Force -ErrorAction SilentlyContinue
        } catch {
            $output = $_ | Out-String
            $exitCode = 125
        }
        $sw.Stop()
        $output | Set-Content -LiteralPath $outFile -Encoding UTF8
        $status = if ($exitCode -eq 0) { "PASS" } else { "FAIL" }
        if ($required -and $status -ne "PASS") { $overall = "FAIL" }
        $results += [ordered]@{name=$name; command=$command; required=$required; status=$status; exit_code=$exitCode; duration_ms=$sw.ElapsedMilliseconds; log=(Resolve-Path $outFile).Path}
        Write-Host "RESULT: $status (exit=$exitCode)"
        if ($status -ne "PASS") {
            $preview = ($output -split "`r?`n" | Select-Object -Last 20) -join "`n"
            if ($preview) { Write-Host "EVIDENCE (last lines):"; Write-Host $preview }
        }
    }
} finally { Pop-Location }

$summary = [ordered]@{timestamp=(Get-Date).ToString('o'); attempt=$attempt; max_attempts=$maxAttempts; status=$overall; checks=$results}
Write-JsonFile (Join-Path $runDir "summary.json") $summary
Write-JsonFile $StatePath ([ordered]@{attempt=$attempt; last_status=$overall; updated_at=(Get-Date).ToString('o')})
Write-Host "HARNESS_RESULT: $overall"
Write-Host "attempt: $attempt/$maxAttempts"
Write-Host "evidence: $runDir"
if ($overall -eq "PASS") { exit 0 } else { exit 1 }
