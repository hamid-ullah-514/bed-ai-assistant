Write-Host "========================================================" -ForegroundColor Green
Write-Host "  Starting B.Ed AI Book Assistant Backend Server" -ForegroundColor Cyan
Write-Host "  Grounding: 6 Prescribed AIOU B.Ed Books (1,534 pages)" -ForegroundColor Yellow
Write-Host "========================================================" -ForegroundColor Green

Set-Location -Path "$PSScriptRoot\backend"
& "C:\Users\HP\AppData\Local\Python\bin\python.exe" -m uvicorn main:app --host 0.0.0.0 --port 8000
