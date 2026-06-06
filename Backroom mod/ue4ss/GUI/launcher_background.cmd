@echo off
REM This is a background service that runs silently
REM Create a scheduled task or just run it once at startup

if "%1"=="" (
    REM First time - start in background
    start "" /B cmd /c "%~dp0launcher_background.cmd"
    exit /b 0
)

REM Background loop - keeps running
:loop
python "%~dp0launcher.py"
timeout /t 5 /nobreak
goto loop
