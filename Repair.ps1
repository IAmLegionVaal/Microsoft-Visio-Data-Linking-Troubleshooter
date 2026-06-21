#requires -Version 5.1
<# Created by Dewald Pretorius. #>
[CmdletBinding(SupportsShouldProcess=$true)]
param(
  [ValidateSet('Diagnose','ResetOfficeCache','FlushDns')][string]$Action='Diagnose',
  [string]$OutputPath=(Join-Path ([Environment]::GetFolderPath('Desktop')) 'Visio_Data_Linking_Repair')
)
$ErrorActionPreference='Stop'
$cachePath="$env:LOCALAPPDATA\Microsoft\Office\16.0\OfficeFileCache"
New-Item -ItemType Directory -Path $OutputPath -Force|Out-Null
$stamp=Get-Date -Format 'yyyyMMdd_HHmmss';$logPath=Join-Path $OutputPath "Repair_$stamp.log"
function Log([string]$Message){$line='{0:u} {1}' -f (Get-Date),$Message;Write-Host $line;Add-Content -LiteralPath $logPath -Value $line}
[ordered]@{Action=$Action;VisioRunning=[bool](Get-Process VISIO -ErrorAction SilentlyContinue);CacheExists=(Test-Path -LiteralPath $cachePath);Graph443=(Test-NetConnection 'graph.microsoft.com' -Port 443 -InformationLevel Quiet -WarningAction SilentlyContinue);Identity443=(Test-NetConnection 'login.microsoftonline.com' -Port 443 -InformationLevel Quiet -WarningAction SilentlyContinue)}|ConvertTo-Json|Set-Content -LiteralPath (Join-Path $OutputPath "PreRepair_$stamp.json")
if($Action -eq 'Diagnose'){Log '[COMPLETE] Snapshot saved.';exit 0}
try{
  if($Action -eq 'ResetOfficeCache' -and $PSCmdlet.ShouldProcess($cachePath,'Back up and reset Office cache')){
    if(Get-Process VISIO -ErrorAction SilentlyContinue){throw 'Close Visio before resetting the cache.'}
    if(Test-Path -LiteralPath $cachePath){$backup="$cachePath.backup-$stamp";Move-Item -LiteralPath $cachePath -Destination $backup -Force;New-Item -ItemType Directory -Path $cachePath -Force|Out-Null;Log "[BACKUP] $backup"}
  }
  elseif($Action -eq 'FlushDns' -and $PSCmdlet.ShouldProcess('Windows DNS client cache','Clear')){Clear-DnsClientCache}
}catch{Log "[FAILED] $($_.Exception.Message)";exit 5}
Log '[COMPLETE] Repair completed.'
exit 0
