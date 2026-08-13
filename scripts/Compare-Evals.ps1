param([Parameter(Mandatory=$true)][string]$ResultsFile)
. (Join-Path $PSScriptRoot "Common.ps1")
$rows=@(Read-JsonFile (Get-FullPath $ResultsFile))
foreach($v in @('A','B')){
 $s=@($rows|Where-Object{$_.variant -eq $v}); $ok=@($s|Where-Object{$_.correct}).Count
 $pct=if($s.Count){[math]::Round(100*$ok/$s.Count,1)}else{0}
 Write-Host "$v accuracy: $ok/$($s.Count) ($pct%)"
}
$a=@($rows|Where-Object{$_.variant -eq 'A' -and $_.correct}).Count
$b=@($rows|Where-Object{$_.variant -eq 'B' -and $_.correct}).Count
if($b -gt $a){Write-Host 'Recommendation: candidate B is better on this eval set; review failures before promotion.'}
elseif($b -eq $a){Write-Host 'Recommendation: no demonstrated improvement.'}
else{Write-Host 'Recommendation: reject candidate B on this eval set.'}
