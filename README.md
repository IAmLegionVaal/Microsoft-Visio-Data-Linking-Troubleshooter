# Microsoft Visio Data Linking Troubleshooter

Created by **Dewald Pretorius**.

`Troubleshooter.ps1` collects data-link, external-refresh, Excel, SQL, and association evidence. `Repair.ps1` adds guarded `Diagnose`, `ResetOfficeCache`, and `FlushDns` actions.

```powershell
.\Repair.ps1 -Action Diagnose
.\Repair.ps1 -Action ResetOfficeCache -WhatIf
.\Repair.ps1 -Action ResetOfficeCache -Confirm
```

Visio must be closed before cache repair. Existing Office cache data is preserved in a timestamped backup folder. Each run saves pre-change evidence and a log. Source-reviewed for Windows PowerShell 5.1; not runtime-tested against every external data provider.
