@echo off
REM Beacon Hunter - Windows Advanced Detection and Removal Tool
REM Detects and kills beacons, backdoors, and malicious sessions using regex patterns

setlocal enabledelayedexpansion

echo ================================================
echo BEACON HUNTER - WINDOWS DEFENSE TOOL
echo ================================================

if "%1"=="monitor" goto monitor
if "%1"=="hunt" goto hunt
if "%1"=="cleanup" goto cleanup
if "%1"=="kill" goto kill

echo Usage:
echo   %0 monitor [interval_seconds]  - Continuous monitoring
echo   %0 hunt                       - Comprehensive threat hunt
echo   %0 cleanup                    - Remove detected threats
echo   %0 kill                       - Kill processes and remove files
echo.
echo This tool uses regex patterns to detect:
echo   - ThunderStorm C2 components
echo   - Generic C2 beacons and implants
echo   - Binary replacements and backdoors
echo   - Persistence mechanisms
echo   - Suspicious network connections
goto end

:monitor
echo Starting continuous monitoring...
set interval=30
if "%2" neq "" set interval=%2

:monitor_loop
echo.
echo [%date% %time%] === MONITORING CYCLE ===

REM Check for ThunderStorm processes
tasklist /FO CSV | findstr /i "bolt cirrus flurry guardian doppler jetstream cloudseed thunderstorm dolphin" >nul
if %errorlevel% equ 0 (
    echo [%date% %time%] WARNING: ThunderStorm processes detected!
    tasklist /FO CSV | findstr /i "bolt cirrus flurry guardian doppler jetstream cloudseed thunderstorm dolphin"
)

REM Check for C2 processes
tasklist /FO CSV | findstr /i "c2 beacon implant agent payload shell reverse" >nul
if %errorlevel% equ 0 (
    echo [%date% %time%] WARNING: C2 processes detected!
    tasklist /FO CSV | findstr /i "c2 beacon implant agent payload shell reverse"
)

REM Check for suspicious network connections
netstat -an | findstr ":8080 :8443 :9000 :9001 :4444 :1337 :6666 :7777 :8888 :9999" >nul
if %errorlevel% equ 0 (
    echo [%date% %time%] WARNING: Suspicious network connections detected!
    netstat -an | findstr ":8080 :8443 :9000 :9001 :4444 :1337 :6666 :7777 :8888 :9999"
)

REM Check for suspicious files
if exist "C:\temp\bolt.exe" echo [%date% %time%] WARNING: ThunderStorm file found: C:\temp\bolt.exe
if exist "C:\temp\cirrus.exe" echo [%date% %time%] WARNING: ThunderStorm file found: C:\temp\cirrus.exe
if exist "C:\temp\flurry.exe" echo [%date% %time%] WARNING: ThunderStorm file found: C:\temp\flurry.exe
if exist "C:\temp\guardian.exe" echo [%date% %time%] WARNING: ThunderStorm file found: C:\temp\guardian.exe
if exist "C:\temp\dolphin.exe" echo [%date% %time%] WARNING: Dolphin malware found: C:\temp\dolphin.exe

REM Check for binary replacements
if exist "C:\Windows\System32\taskmgr.exe" (
    echo [%date% %time%] WARNING: Task Manager replacement detected!
    certutil -hashfile C:\Windows\System32\taskmgr.exe MD5
)

REM Check registry for persistence
reg query "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Run" | findstr /i "bolt cirrus flurry guardian dolphin" >nul
if %errorlevel% equ 0 (
    echo [%date% %time%] WARNING: Suspicious registry entries found!
    reg query "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Run" | findstr /i "bolt cirrus flurry guardian dolphin"
)

reg query "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" | findstr /i "bolt cirrus flurry guardian dolphin" >nul
if %errorlevel% equ 0 (
    echo [%date% %time%] WARNING: Suspicious registry entries found!
    reg query "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" | findstr /i "bolt cirrus flurry guardian dolphin"
)

echo [%date% %time%] Monitoring complete. Waiting %interval% seconds...
timeout /t %interval% /nobreak >nul
goto monitor_loop

:hunt
echo.
echo ================================================
echo COMPREHENSIVE THREAT HUNT - WINDOWS
echo ================================================

echo [%date% %time%] Starting comprehensive threat hunt...

echo.
echo --- PROCESS ANALYSIS ---
echo Checking for ThunderStorm processes:
tasklist /FO CSV | findstr /i "bolt cirrus flurry guardian doppler jetstream cloudseed thunderstorm dolphin"

echo.
echo Checking for C2 processes:
tasklist /FO CSV | findstr /i "c2 beacon implant agent payload shell reverse"

echo.
echo Checking for PowerShell processes:
tasklist /FO CSV | findstr /i "powershell"

echo.
echo --- NETWORK ANALYSIS ---
echo Checking for suspicious ports:
netstat -an | findstr ":8080 :8443 :9000 :9001 :4444 :1337 :6666 :7777 :8888 :9999"

echo.
echo Checking for established connections:
netstat -an | findstr "ESTABLISHED" | findstr ":8080 :8443 :9000 :9001 :4444 :1337 :6666 :7777 :8888 :9999"

echo.
echo --- FILE SYSTEM ANALYSIS ---
echo Checking for ThunderStorm files:
if exist "C:\temp\bolt.exe" echo FOUND: C:\temp\bolt.exe
if exist "C:\temp\cirrus.exe" echo FOUND: C:\temp\cirrus.exe
if exist "C:\temp\flurry.exe" echo FOUND: C:\temp\flurry.exe
if exist "C:\temp\guardian.exe" echo FOUND: C:\temp\guardian.exe
if exist "C:\temp\dolphin.exe" echo FOUND: C:\temp\dolphin.exe
if exist "C:\Windows\Temp\bolt.exe" echo FOUND: C:\Windows\Temp\bolt.exe
if exist "C:\Windows\Temp\cirrus.exe" echo FOUND: C:\Windows\Temp\cirrus.exe
if exist "C:\ProgramData\bolt.exe" echo FOUND: C:\ProgramData\bolt.exe
if exist "C:\ProgramData\cirrus.exe" echo FOUND: C:\ProgramData\cirrus.exe

echo.
echo Checking for binary replacements:
if exist "C:\Windows\System32\taskmgr.exe" (
    echo FOUND: C:\Windows\System32\taskmgr.exe
    echo Checking file integrity:
    certutil -hashfile C:\Windows\System32\taskmgr.exe MD5
)
if exist "C:\Windows\System32\cmd.exe" (
    echo FOUND: C:\Windows\System32\cmd.exe
    echo Checking file integrity:
    certutil -hashfile C:\Windows\System32\cmd.exe MD5
)

echo.
echo --- PERSISTENCE ANALYSIS ---
echo Checking HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Run:
reg query "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Run" | findstr /i "bolt cirrus flurry guardian dolphin"

echo.
echo Checking HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Run:
reg query "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" | findstr /i "bolt cirrus flurry guardian dolphin"

echo.
echo Checking services:
sc query | findstr /i "bolt cirrus flurry guardian dolphin"

echo.
echo Checking scheduled tasks:
schtasks /query /fo table | findstr /i "bolt cirrus flurry guardian dolphin"

echo.
echo --- STARTUP FOLDER ANALYSIS ---
echo Checking user startup folder:
dir "%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup" | findstr /i "bolt cirrus flurry guardian"

echo.
echo Checking system startup folder:
dir "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Startup" | findstr /i "bolt cirrus flurry guardian"

echo.
echo [%date% %time%] Comprehensive threat hunt complete!
goto end

:cleanup
echo.
echo ================================================
echo THREAT CLEANUP - WINDOWS
echo ================================================

echo [%date% %time%] Starting threat cleanup...

echo Killing malicious processes...
taskkill /F /IM bolt.exe 2>nul && echo SUCCESS: Killed bolt.exe
taskkill /F /IM cirrus.exe 2>nul && echo SUCCESS: Killed cirrus.exe
taskkill /F /IM flurry.exe 2>nul && echo SUCCESS: Killed flurry.exe
taskkill /F /IM guardian.exe 2>nul && echo SUCCESS: Killed guardian.exe
taskkill /F /IM dolphin.exe 2>nul && echo SUCCESS: Killed dolphin.exe
taskkill /F /IM doppler.exe 2>nul && echo SUCCESS: Killed doppler.exe
taskkill /F /IM jetstream.exe 2>nul && echo SUCCESS: Killed jetstream.exe
taskkill /F /IM cloudseed.exe 2>nul && echo SUCCESS: Killed cloudseed.exe

echo.
echo Removing suspicious files...
del /F /Q "C:\temp\bolt.exe" 2>nul && echo SUCCESS: Removed C:\temp\bolt.exe
del /F /Q "C:\temp\cirrus.exe" 2>nul && echo SUCCESS: Removed C:\temp\cirrus.exe
del /F /Q "C:\temp\flurry.exe" 2>nul && echo SUCCESS: Removed C:\temp\flurry.exe
del /F /Q "C:\temp\guardian.exe" 2>nul && echo SUCCESS: Removed C:\temp\guardian.exe
del /F /Q "C:\temp\dolphin.exe" 2>nul && echo SUCCESS: Removed C:\temp\dolphin.exe
del /F /Q "C:\Windows\Temp\bolt.exe" 2>nul && echo SUCCESS: Removed C:\Windows\Temp\bolt.exe
del /F /Q "C:\Windows\Temp\cirrus.exe" 2>nul && echo SUCCESS: Removed C:\Windows\Temp\cirrus.exe
del /F /Q "C:\ProgramData\bolt.exe" 2>nul && echo SUCCESS: Removed C:\ProgramData\bolt.exe
del /F /Q "C:\ProgramData\cirrus.exe" 2>nul && echo SUCCESS: Removed C:\ProgramData\cirrus.exe

echo.
echo Cleaning registry persistence...
reg delete "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Run" /v "bolt" /f 2>nul && echo SUCCESS: Removed bolt from registry
reg delete "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Run" /v "cirrus" /f 2>nul && echo SUCCESS: Removed cirrus from registry
reg delete "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Run" /v "flurry" /f 2>nul && echo SUCCESS: Removed flurry from registry
reg delete "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Run" /v "guardian" /f 2>nul && echo SUCCESS: Removed guardian from registry
reg delete "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Run" /v "dolphin" /f 2>nul && echo SUCCESS: Removed dolphin from registry

reg delete "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" /v "bolt" /f 2>nul && echo SUCCESS: Removed bolt from system registry
reg delete "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" /v "cirrus" /f 2>nul && echo SUCCESS: Removed cirrus from system registry
reg delete "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" /v "flurry" /f 2>nul && echo SUCCESS: Removed flurry from system registry
reg delete "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" /v "guardian" /f 2>nul && echo SUCCESS: Removed guardian from system registry
reg delete "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" /v "dolphin" /f 2>nul && echo SUCCESS: Removed dolphin from system registry

echo.
echo Stopping malicious services...
sc stop bolt 2>nul && echo SUCCESS: Stopped bolt service
sc stop cirrus 2>nul && echo SUCCESS: Stopped cirrus service
sc stop flurry 2>nul && echo SUCCESS: Stopped flurry service
sc stop guardian 2>nul && echo SUCCESS: Stopped guardian service
sc stop dolphin 2>nul && echo SUCCESS: Stopped dolphin service

sc delete bolt 2>nul && echo SUCCESS: Deleted bolt service
sc delete cirrus 2>nul && echo SUCCESS: Deleted cirrus service
sc delete flurry 2>nul && echo SUCCESS: Deleted flurry service
sc delete guardian 2>nul && echo SUCCESS: Deleted guardian service
sc delete dolphin 2>nul && echo SUCCESS: Deleted dolphin service

echo.
echo Removing scheduled tasks...
schtasks /delete /tn "bolt" /f 2>nul && echo SUCCESS: Deleted bolt scheduled task
schtasks /delete /tn "cirrus" /f 2>nul && echo SUCCESS: Deleted cirrus scheduled task
schtasks /delete /tn "flurry" /f 2>nul && echo SUCCESS: Deleted flurry scheduled task
schtasks /delete /tn "guardian" /f 2>nul && echo SUCCESS: Deleted guardian scheduled task
schtasks /delete /tn "dolphin" /f 2>nul && echo SUCCESS: Deleted dolphin scheduled task

echo.
echo Cleaning startup folders...
del /F /Q "%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup\bolt.*" 2>nul && echo SUCCESS: Removed bolt from startup
del /F /Q "%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup\cirrus.*" 2>nul && echo SUCCESS: Removed cirrus from startup
del /F /Q "%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup\flurry.*" 2>nul && echo SUCCESS: Removed flurry from startup
del /F /Q "%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup\guardian.*" 2>nul && echo SUCCESS: Removed guardian from startup
del /F /Q "%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup\dolphin.*" 2>nul && echo SUCCESS: Removed dolphin from startup

del /F /Q "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Startup\bolt.*" 2>nul && echo SUCCESS: Removed bolt from system startup
del /F /Q "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Startup\cirrus.*" 2>nul && echo SUCCESS: Removed cirrus from system startup
del /F /Q "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Startup\flurry.*" 2>nul && echo SUCCESS: Removed flurry from system startup
del /F /Q "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Startup\guardian.*" 2>nul && echo SUCCESS: Removed guardian from system startup
del /F /Q "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Startup\dolphin.*" 2>nul && echo SUCCESS: Removed dolphin from system startup

echo.
echo [%date% %time%] Threat cleanup complete!
goto end

:kill
echo.
echo ================================================
echo KILLING THREATS - WINDOWS
echo ================================================

echo [%date% %time%] Killing detected threats...

echo Killing ThunderStorm processes...
taskkill /F /IM bolt.exe 2>nul && echo SUCCESS: Killed bolt.exe
taskkill /F /IM cirrus.exe 2>nul && echo SUCCESS: Killed cirrus.exe
taskkill /F /IM flurry.exe 2>nul && echo SUCCESS: Killed flurry.exe
taskkill /F /IM guardian.exe 2>nul && echo SUCCESS: Killed guardian.exe
taskkill /F /IM dolphin.exe 2>nul && echo SUCCESS: Killed dolphin.exe

echo.
echo Killing C2 processes...
taskkill /F /IM c2.exe 2>nul && echo SUCCESS: Killed c2.exe
taskkill /F /IM beacon.exe 2>nul && echo SUCCESS: Killed beacon.exe
taskkill /F /IM implant.exe 2>nul && echo SUCCESS: Killed implant.exe
taskkill /F /IM agent.exe 2>nul && echo SUCCESS: Killed agent.exe
taskkill /F /IM payload.exe 2>nul && echo SUCCESS: Killed payload.exe

echo.
echo Removing suspicious files...
del /F /Q "C:\temp\bolt.exe" 2>nul && echo SUCCESS: Removed C:\temp\bolt.exe
del /F /Q "C:\temp\cirrus.exe" 2>nul && echo SUCCESS: Removed C:\temp\cirrus.exe
del /F /Q "C:\temp\flurry.exe" 2>nul && echo SUCCESS: Removed C:\temp\flurry.exe
del /F /Q "C:\temp\guardian.exe" 2>nul && echo SUCCESS: Removed C:\temp\guardian.exe
del /F /Q "C:\temp\dolphin.exe" 2>nul && echo SUCCESS: Removed C:\temp\dolphin.exe

del /F /Q "C:\Windows\Temp\bolt.exe" 2>nul && echo SUCCESS: Removed C:\Windows\Temp\bolt.exe
del /F /Q "C:\Windows\Temp\cirrus.exe" 2>nul && echo SUCCESS: Removed C:\Windows\Temp\cirrus.exe
del /F /Q "C:\ProgramData\bolt.exe" 2>nul && echo SUCCESS: Removed C:\ProgramData\bolt.exe
del /F /Q "C:\ProgramData\cirrus.exe" 2>nul && echo SUCCESS: Removed C:\ProgramData\cirrus.exe

echo.
echo [%date% %time%] Threat killing complete!
goto end

:end
echo.
echo Beacon Hunter complete. 