$ErrorActionPreference = "Stop"
$Root = Split-Path -Parent $MyInvocation.MyCommand.Path
$Backend = Join-Path $Root "backend"
$Frontend = Join-Path $Root "frontend"

function Stop-PortProcess {
  param([int]$Port)
  try {
    $listeners = Get-NetTCPConnection -LocalPort $Port -State Listen -ErrorAction SilentlyContinue
    foreach ($listener in $listeners) {
      $pidToStop = $listener.OwningProcess
      if ($pidToStop -and $pidToStop -ne $PID) {
        Write-Host "Stopping old process on port $Port (PID $pidToStop)..." -ForegroundColor Yellow
        Stop-Process -Id $pidToStop -Force -ErrorAction SilentlyContinue
      }
    }
  } catch {
    Write-Warning "Could not inspect port $Port. If startup fails, close old TerraSentry PowerShell windows and retry."
  }
}

if (-not (Test-Path (Join-Path $Backend ".venv\Scripts\python.exe"))) {
  Write-Host "Backend environment missing. Running setup first..." -ForegroundColor Yellow
  & (Join-Path $Root "setup-windows.ps1")
}
if (-not (Test-Path (Join-Path $Frontend "node_modules"))) {
  Write-Host "Frontend dependencies missing. Running setup first..." -ForegroundColor Yellow
  & (Join-Path $Root "setup-windows.ps1")
}

# Always point this frontend at this package's backend.
"VITE_API_BASE=http://127.0.0.1:8000" | Set-Content (Join-Path $Frontend ".env")

# Critical: prevent an older TerraSentry build from continuing to occupy these ports.
Stop-PortProcess 8000
Stop-PortProcess 5173
Start-Sleep -Seconds 1

# Verify bundled event imagery before launching.
$RequiredAssets = @(
  "demo\remal\before.jpg", "demo\remal\after.jpg", "demo\remal\reference.jpg", "demo\remal\change.jpg",
  "demo\otis\before.jpg", "demo\otis\after.jpg", "demo\otis\reference.jpg", "demo\otis\change.jpg",
  "demo\mumbai\before.jpg", "demo\mumbai\after.jpg", "demo\mumbai\reference.jpg", "demo\mumbai\change.jpg",
  "demo\tobago\before.jpg", "demo\tobago\after.jpg", "demo\tobago\reference.jpg", "demo\tobago\change.jpg"
)
$Missing = @()
foreach ($rel in $RequiredAssets) {
  $full = Join-Path $Root $rel
  if (-not (Test-Path $full) -or (Get-Item $full).Length -lt 10000) { $Missing += $rel }
}
if ($Missing.Count -gt 0) {
  Write-Host "WARNING: These bundled images are missing or too small:" -ForegroundColor Red
  $Missing | ForEach-Object { Write-Host "  $_" -ForegroundColor Red }
} else {
  Write-Host "Verified: all 16 bundled event images are present." -ForegroundColor Green
}

$backendCmd = "Set-Location '$Backend'; & '.\.venv\Scripts\Activate.ps1'; uvicorn app.main:app --host 127.0.0.1 --port 8000"
$frontendCmd = "Set-Location '$Frontend'; npm run dev -- --host 127.0.0.1 --port 5173 --strictPort"
Start-Process powershell -ArgumentList '-NoExit','-ExecutionPolicy','Bypass','-Command',$backendCmd
Start-Sleep -Seconds 3
Start-Process powershell -ArgumentList '-NoExit','-ExecutionPolicy','Bypass','-Command',$frontendCmd
Start-Sleep -Seconds 4

Write-Host "TerraSentry 5.6.5 started from:" -ForegroundColor Green
Write-Host $Root
Write-Host "Frontend: http://localhost:5173"
Write-Host "Backend:  http://localhost:8000/api/health"
Write-Host "If Chrome was already open on localhost:5173, press Ctrl+Shift+R once." -ForegroundColor Cyan
Start-Process "http://localhost:5173"
