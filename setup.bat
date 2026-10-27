@echo off
setlocal
cd /d "%~dp0"
echo ===========================================================
echo ISSD CAT 2 - Group VM Setup (no Vagrant required)
echo ===========================================================
if not exist "%~dp0setup.ps1" (
  echo ERROR: setup.ps1 must be in the same directory as setup.bat.
  pause
  exit /b 1
)
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%~dp0setup.ps1"
set "RESULT=%ERRORLEVEL%"
echo.
if not "%RESULT%"=="0" (echo Setup stopped. Read the error above. No existing VM was intentionally deleted.) else (echo Setup steps finished. Check the summary above.)
pause
exit /b %RESULT%
