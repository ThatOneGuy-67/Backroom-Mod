@echo off
REM Place this in Windows Startup folder to auto-run:
REM C:\Users\<YourUsername>\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup\

REM Run the GUI launcher silently
cd /d "D:\SteamLibrary\steamapps\common\EscapeTheBackrooms\EscapeTheBackrooms\Binaries\Win64\ue4ss\GUI"
cscript.exe run_gui_launcher_silent.vbs
exit
