@echo off
title B.Ed AI Book Assistant Website
echo ========================================================
echo   Launching B.Ed AI Book Assistant Web Application
echo   Opening Website at: http://localhost:8000
echo ========================================================
echo.
start http://localhost:8000
cd /d "%~dp0\backend"
"C:\Users\HP\AppData\Local\Python\bin\python.exe" -m uvicorn main:app --host 0.0.0.0 --port 8000
pause
