param(
    [Parameter(Mandatory=$true)][string]$BaselinePrompt,
    [Parameter(Mandatory=$true)][string]$CandidatePrompt,
    [string]$EvalSet = "reviewer",
    [string]$Model,
    [int]$Repetitions = 1
)
. (Join-Path $PSScriptRoot "Common.ps1")
$RepoRoot=Split-Path -Parent $PSScriptRoot
$codex=Get-Command codex -ErrorAction Stop
$casesDir=Join-Path $RepoRoot "evals/$EvalSet/cases"
if (-not (Test-Path $casesDir)) { throw "Eval set not found: $casesDir" }
$stamp=Get-Date -Format 'yyyyMMdd-HHmmss'
$outRoot=Join-Path $RepoRoot "eval-results/$stamp-$EvalSet"
Ensure-Directory $outRoot
$schema=Join-Path $RepoRoot 'schemas/eval-result.schema.json'
$rows=@()
foreach($case in Get-ChildItem $casesDir -Directory | Sort-Object Name){
    $inputPath=Join-Path $case.FullName 'input.md'
    $expectedPath=Join-Path $case.FullName 'expected.json'
    if (-not (Test-Path $inputPath) -or -not (Test-Path $expectedPath)){continue}
    $input=Get-Content $inputPath -Raw
    $expected=Read-JsonFile $expectedPath
    foreach($variant in @(@{name='A';path=$BaselinePrompt},@{name='B';path=$CandidatePrompt})){
      $promptPath=[string]$variant.path
      if (-not [IO.Path]::IsPathRooted($promptPath)) { $promptPath=Join-Path $RepoRoot $promptPath }
      $role=Get-Content (Get-FullPath $promptPath) -Raw
      for($r=1;$r -le $Repetitions;$r++){
        $outputFile=Join-Path $outRoot ("{0}-{1}-r{2}.json" -f $case.Name,$variant.name,$r)
        $prompt=$role+"`n`n# Evaluation case`n"+$input+"`n`nReturn only the requested structured result."
        $args=@('exec','--skip-git-repo-check','--sandbox','read-only','--output-schema',$schema,'--output-last-message',$outputFile)
        if($Model){$args+=@('--model',$Model)}
        $args+=$prompt
        & $codex.Source @args | Out-Null
        $actual=$null
        try{$actual=Read-JsonFile $outputFile}catch{}
        $correct=$false
        if($actual){
          $correct=([string]$actual.status -eq [string]$expected.status)
          if($correct -and $expected.must_contain){
            $hay=($actual.findings -join ' ').ToLowerInvariant()
            foreach($needle in @($expected.must_contain)){if(-not $hay.Contains(([string]$needle).ToLowerInvariant())){$correct=$false}}
          }
        }
        $rows += [ordered]@{case=$case.Name;variant=$variant.name;repetition=$r;correct=$correct;status=if($actual){$actual.status}else{'PARSE_ERROR'};output=$outputFile}
      }
    }
}
Write-JsonFile (Join-Path $outRoot 'results.json') $rows
foreach($v in @('A','B')){
 $subset=@($rows|Where-Object{$_.variant -eq $v}); $ok=@($subset|Where-Object{$_.correct}).Count
 $pct=if($subset.Count){[math]::Round(100*$ok/$subset.Count,1)}else{0}
 Write-Host "$v: $ok/$($subset.Count) correct ($pct%)"
}
Write-Host "Results: $outRoot"
