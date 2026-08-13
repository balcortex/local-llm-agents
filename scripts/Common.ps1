Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

function Get-FullPath([string]$Path) {
    return [System.IO.Path]::GetFullPath((Resolve-Path $Path).Path)
}

function Get-Sha256([string]$Path) {
    if (-not (Test-Path -LiteralPath $Path -PathType Leaf)) { return $null }
    return (Get-FileHash -LiteralPath $Path -Algorithm SHA256).Hash.ToLowerInvariant()
}

function Ensure-Directory([string]$Path) {
    New-Item -ItemType Directory -Path $Path -Force | Out-Null
}

function Read-JsonFile([string]$Path) {
    if (-not (Test-Path -LiteralPath $Path)) { return $null }
    return Get-Content -LiteralPath $Path -Raw | ConvertFrom-Json
}

function Write-JsonFile([string]$Path, $Object) {
    Ensure-Directory (Split-Path -Parent $Path)
    $Object | ConvertTo-Json -Depth 20 | Set-Content -LiteralPath $Path -Encoding UTF8
}

function Get-SourceVersion([string]$SourceRoot) {
    $versionPath = Join-Path $SourceRoot "VERSION"
    if (Test-Path $versionPath) { return (Get-Content $versionPath -Raw).Trim() }
    return "unknown"
}

function Get-SourceCommit([string]$SourceRoot) {
    try {
        $git = Get-Command git -ErrorAction Stop
        $value = & $git.Source -C $SourceRoot rev-parse HEAD 2>$null
        if ($LASTEXITCODE -eq 0) { return ($value | Select-Object -First 1).Trim() }
    } catch {}
    return "unknown"
}

function Add-GitIgnoreEntry([string]$ProjectRoot, [string]$Entry) {
    $path = Join-Path $ProjectRoot ".gitignore"
    $lines = @()
    if (Test-Path $path) { $lines = @(Get-Content $path) }
    if ($lines -notcontains $Entry) {
        Add-Content -LiteralPath $path -Value $Entry -Encoding UTF8
    }
}
