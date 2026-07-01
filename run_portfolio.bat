@echo off
echo =======================================================
echo     ZAID ALI PORTFOLIO - AUTOMATED STARTUP SCRIPT
echo =======================================================
echo.
echo [1/2] Starting local Backend API Server on Port 5000...
start "Backend API Server" /min cmd /c "cd /d d:\Automation\Codiora Internship\K projects\Week 1 portfolio\server && node server.js"
echo [OK] Backend API Server launched in a minimized window.
echo.
echo [2/2] Running Flutter Portfolio App...
flutter run
echo.
pause
