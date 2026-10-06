$ErrorActionPreference = "Stop"
$Root = Split-Path -Parent $MyInvocation.MyCommand.Path
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass -Force
Get-ChildItem $Root -Recurse -Filter *.ps1 | Unblock-File
if (-not (Test-Path (Join-Path $Root "backend\.venv\Scripts\python.exe")) -or -not (Test-Path (Join-Path $Root "frontend\node_modules"))) {
  & (Join-Path $Root "setup-windows.ps1")
}
& (Join-Path $Root "start-windows.ps1")
