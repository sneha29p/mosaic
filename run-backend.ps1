$ErrorActionPreference = "Stop"
Set-Location "$PSScriptRoot\backend"
if (-not (Test-Path ".venv\Scripts\python.exe")) {
  python -m venv .venv
  & ".\.venv\Scripts\python.exe" -m pip install --upgrade pip
  & ".\.venv\Scripts\python.exe" -m pip install -r requirements.txt
}
Set-ExecutionPolicy -Scope Process -ExecutionPolicy RemoteSigned -Force
& ".\.venv\Scripts\Activate.ps1"
uvicorn app.main:app --reload --host 0.0.0.0 --port 8000
