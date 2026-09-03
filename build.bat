@echo off
echo Building fonts
powershell -ExecutionPolicy Bypass -NoProfile -File "%~dp0src\ui\resource\build_fonts.ps1"
pause