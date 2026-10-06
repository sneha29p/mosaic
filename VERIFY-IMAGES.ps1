$Root = Split-Path -Parent $MyInvocation.MyCommand.Path
Write-Host "TerraSentry package: $Root" -ForegroundColor Cyan
$files = Get-ChildItem (Join-Path $Root "demo") -Recurse -File | Where-Object { $_.Name -in @('before.jpg','after.jpg','reference.jpg','change.jpg') }
$files | Select-Object @{n='Case';e={$_.Directory.Name}}, Name, @{n='KB';e={[math]::Round($_.Length/1KB,1)}} | Format-Table -AutoSize
Write-Host "Found $($files.Count) bundled event images. Expected: 16." -ForegroundColor $(if($files.Count -eq 16){'Green'}else{'Red'})
