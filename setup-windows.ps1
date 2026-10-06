$ErrorActionPreference = "Stop"
$Root = Split-Path -Parent $MyInvocation.MyCommand.Path
Write-Host "TerraSentry 5.6.5 Windows setup" -ForegroundColor Cyan

$Backend = Join-Path $Root "backend"
$Frontend = Join-Path $Root "frontend"

Set-Location $Backend
if (-not (Test-Path ".venv")) {
  Write-Host "Creating Python virtual environment..."
  python -m venv .venv
}
& ".\.venv\Scripts\python.exe" -m pip install --upgrade pip
& ".\.venv\Scripts\python.exe" -m pip install -r requirements.txt

Set-Location $Frontend
if (-not (Test-Path ".env")) {
  "VITE_API_BASE=http://127.0.0.1:8000" | Set-Content ".env"
}
npm install

Set-Location $Root
$DemoBefore = Join-Path $Root "demo\remal\before.jpg"
if (-not (Test-Path $DemoBefore)) {
  Write-Host "Caching real public EO demo imagery for offline presentation..." -ForegroundColor Cyan
  try {
    & (Join-Path $Root "demo\remal\fetch-demo-assets.ps1")
  } catch {
    Write-Warning "Could not cache the real EO imagery now. TerraSentry will still run; rerun .\demo\remal\fetch-demo-assets.ps1 when internet access is available."
  }
}

Write-Host "Caching source-backed event imagery where available..." -ForegroundColor Cyan
try {
  & (Join-Path $Root "demo\fetch-event-assets.ps1")
} catch {
  Write-Warning "Some event imagery could not be cached. TerraSentry will use remote source URLs or clean empty states instead."
}

Write-Host "Setup complete." -ForegroundColor Green
Write-Host "Run: .\start-windows.ps1"
