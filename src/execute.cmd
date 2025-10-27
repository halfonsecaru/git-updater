@echo off
setlocal
set "SCRIPT=%~dp0push-projects.ps1"
where pwsh >nul 2>&1
if %ERRORLEVEL%==0 (
  pwsh "%SCRIPT%" %*
) else (
  powershell -ExecutionPolicy Bypass -File "%SCRIPT%" %*
)