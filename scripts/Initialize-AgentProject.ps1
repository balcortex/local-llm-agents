param(
    [string]$ProjectRoot = ".",
    [switch]$Force
)
. (Join-Path $PSScriptRoot "Common.ps1")
$ProjectRoot = Get-FullPath $ProjectRoot
$AgentDir = Join-Path $ProjectRoot ".agent"
$ConfigPath = Join-Path $AgentDir "project.json"
Ensure-Directory $AgentDir

if ((Test-Path $ConfigPath) -and -not $Force) {
    Write-Host "Existing configuration kept: $ConfigPath"
    exit 0
}

$checks = @()
$packageJson = Join-Path $ProjectRoot "package.json"
if (Test-Path $packageJson) {
    try {
        $pkg = Get-Content $packageJson -Raw | ConvertFrom-Json
        $scriptNames = @($pkg.scripts.PSObject.Properties.Name)
        if ($scriptNames -contains "test") { $checks += [ordered]@{name="tests"; command="npm test"; required=$true; timeout_seconds=600} }
        if ($scriptNames -contains "lint") { $checks += [ordered]@{name="lint"; command="npm run lint"; required=$false; timeout_seconds=300} }
        if ($scriptNames -contains "build") { $checks += [ordered]@{name="build"; command="npm run build"; required=$false; timeout_seconds=600} }
    } catch { Write-Warning "Could not parse package.json: $($_.Exception.Message)" }
}

$pyproject = Join-Path $ProjectRoot "pyproject.toml"
$pytestIni = Join-Path $ProjectRoot "pytest.ini"
if ((Test-Path $pyproject) -or (Test-Path $pytestIni) -or (Test-Path (Join-Path $ProjectRoot "tests"))) {
    if (-not ($checks | Where-Object {$_.name -eq "tests"})) {
        $checks += [ordered]@{name="tests"; command="python -m pytest"; required=$true; timeout_seconds=600}
    }
    if (Test-Path $pyproject) {
        $text = Get-Content $pyproject -Raw
        if ($text -match "(?m)^\[tool\.ruff") { $checks += [ordered]@{name="lint"; command="python -m ruff check ."; required=$false; timeout_seconds=300} }
    }
}

$sln = Get-ChildItem -LiteralPath $ProjectRoot -Filter "*.sln" -File -ErrorAction SilentlyContinue | Select-Object -First 1
$csproj = Get-ChildItem -LiteralPath $ProjectRoot -Filter "*.csproj" -File -ErrorAction SilentlyContinue | Select-Object -First 1
if ($sln -or $csproj) {
    if (-not ($checks | Where-Object {$_.name -eq "tests"})) { $checks += [ordered]@{name="tests"; command="dotnet test"; required=$true; timeout_seconds=900} }
}

if ($checks.Count -eq 0) {
    $checks += [ordered]@{name="configure-me"; command='cmd /c "echo No validation checks configured. Edit .agent/project.json ^& exit /b 2"'; required=$true; timeout_seconds=60}
}

$config = [ordered]@{schema_version=1; max_validation_attempts=2; checks=$checks}
Write-JsonFile $ConfigPath $config
Write-Host "Created: $ConfigPath"
Write-Host "Detected checks:"
$checks | ForEach-Object { Write-Host " - $($_.name): $($_.command) (required=$($_.required))" }
