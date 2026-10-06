$ErrorActionPreference = "Stop"
Set-Location "$PSScriptRoot\frontend"
if (-not (Test-Path ".env")) { "VITE_API_BASE=http://127.0.0.1:8000" | Set-Content ".env" }
if (-not (Test-Path "node_modules")) { npm install }
npm run dev
