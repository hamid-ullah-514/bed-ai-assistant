@echo off
title B.Ed AI Book Assistant Backend & Website
echo ========================================================
echo   Starting B.Ed AI Book Assistant Server & Website
echo   Exclusively Grounded in 6 Official AIOU Textbooks
echo   Web Address: http://localhost:8000
echo ========================================================
echo.
start http://localhost:8000
cd /d "%~dp0\backend"
"C:\Users\HP\AppData\Local\Python\bin\python.exe" -m uvicorn main:app --host 0.0.0.0 --port 8000
pause
