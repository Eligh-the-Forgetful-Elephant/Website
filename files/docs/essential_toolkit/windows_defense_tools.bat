@echo off
REM Windows Defense Tools for PVJ CTF
REM Uses only built-in Windows commands - no external dependencies

setlocal enabledelayedexpansion

echo ================================================
echo WINDOWS DEFENSE TOOLKIT - PVJ CTF
echo ================================================

if "%1"=="monitor" goto monitor
if "%1"=="hunt" goto hunt
if "%1"=="cleanup" goto cleanup
if "%1"=="quickcheck" goto quickcheck

echo Usage:
echo   %0 monitor [interval_seconds]
echo   %0 hunt
echo   %0 cleanup
echo   %0 quickcheck
goto end

:monitor
echo Starting continuous monitoring...
set interval=60
if "%2" neq "" set interval=%2

:monitor_loop
echo.
echo [%date% %time%] Checking for ThunderStorm activity...

REM Check for suspicious processes
tasklist /FO CSV | findstr /i "bolt cirrus flurry guardian doppler jetstream cloudseed thunderstorm dolphin" >nul
if %errorlevel% equ 0 (
    echo [%date% %time%] WARNING: Suspicious process detected!
    tasklist /FO CSV | findstr /i "bolt cirrus flurry guardian doppler jetstream cloudseed thunderstorm dolphin"
)

REM Check for dolphin malware (task manager replacement)
tasklist | findstr dolphin >nul
if %errorlevel% equ 0 (
    echo [%date% %time%] WARNING: Dolphin malware detected!
    tasklist | findstr dolphin
)

REM Check for suspicious network connections
netstat -an | findstr ":8080 :8443 :9000 :9001 :4444 :1337" >nul
if %errorlevel% equ 0 (
    echo [%date% %time%] WARNING: Suspicious network connection detected!
    netstat -an | findstr ":8080 :8443 :9000 :9001 :4444 :1337"
)

REM Check for suspicious files
if exist "C:\temp\bolt.exe" echo [%date% %time%] WARNING: ThunderStorm file found: C:\temp\bolt.exe
if exist "C:\temp\cirrus.exe" echo [%date% %time%] WARNING: ThunderStorm file found: C:\temp\cirrus.exe
if exist "C:\Windows\Temp\bolt.exe" echo [%date% %time%] WARNING: ThunderStorm file found: C:\Windows\Temp\bolt.exe
if exist "C:\Windows\Temp\cirrus.exe" echo [%date% %time%] WARNING: ThunderStorm file found: C:\Windows\Temp\cirrus.exe

REM Check for dolphin malware files
if exist "C:\Windows\System32\dolphin.exe" echo [%date% %time%] WARNING: Dolphin malware found: C:\Windows\System32\dolphin.exe
if exist "C:\temp\dolphin.exe" echo [%date% %time%] WARNING: Dolphin malware found: C:\temp\dolphin.exe

REM Check registry for persistence
reg query "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Run" | findstr /i "bolt cirrus flurry guardian" >nul
if %errorlevel% equ 0 (
    echo [%date% %time%] WARNING: Suspicious registry entry found!
    reg query "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Run" | findstr /i "bolt cirrus flurry guardian"
)

reg query "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" | findstr /i "bolt cirrus flurry guardian" >nul
if %errorlevel% equ 0 (
    echo [%date% %time%] WARNING: Suspicious registry entry found!
    reg query "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" | findstr /i "bolt cirrus flurry guardian"
)

echo [%date% %time%] Monitoring complete. Waiting %interval% seconds...
timeout /t %interval% /nobreak >nul
goto monitor_loop

:hunt
echo.
echo ================================================
echo THUNDERSTORM HUNT - WINDOWS
echo ================================================

echo [%date% %time%] Starting comprehensive ThunderStorm hunt...

echo.
echo --- CHECKING PROCESSES ---
tasklist /FO CSV | findstr /i "bolt cirrus flurry guardian doppler jetstream cloudseed thunderstorm"

echo.
echo --- CHECKING NETWORK CONNECTIONS ---
netstat -an | findstr ":8080 :8443 :9000 :9001 :4444 :1337"

echo.
echo --- CHECKING SUSPICIOUS FILES ---
if exist "C:\temp\bolt.exe" echo FOUND: C:\temp\bolt.exe
if exist "C:\temp\cirrus.exe" echo FOUND: C:\temp\cirrus.exe
if exist "C:\temp\flurry.exe" echo FOUND: C:\temp\flurry.exe
if exist "C:\temp\guardian.exe" echo FOUND: C:\temp\guardian.exe
if exist "C:\Windows\Temp\bolt.exe" echo FOUND: C:\Windows\Temp\bolt.exe
if exist "C:\Windows\Temp\cirrus.exe" echo FOUND: C:\Windows\Temp\cirrus.exe
if exist "C:\ProgramData\bolt.exe" echo FOUND: C:\ProgramData\bolt.exe
if exist "C:\ProgramData\cirrus.exe" echo FOUND: C:\ProgramData\cirrus.exe

echo --- CHECKING DOLPHIN MALWARE ---
if exist "C:\Windows\System32\dolphin.exe" echo FOUND: C:\Windows\System32\dolphin.exe
if exist "C:\temp\dolphin.exe" echo FOUND: C:\temp\dolphin.exe
if exist "C:\Windows\System32\taskmgr.exe" (
    echo Task Manager exists - checking if legitimate...
    certutil -hashfile C:\Windows\System32\taskmgr.exe MD5
)

echo.
echo --- CHECKING REGISTRY PERSISTENCE ---
echo Checking HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Run:
reg query "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Run" | findstr /i "bolt cirrus flurry guardian"

echo.
echo Checking HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Run:
reg query "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" | findstr /i "bolt cirrus flurry guardian"

echo.
echo --- CHECKING SERVICES ---
sc query | findstr /i "bolt cirrus flurry guardian dolphin"

echo --- CHECKING SCHEDULED TASKS ---
schtasks /query /fo table | findstr /i "dolphin bolt cirrus flurry guardian"

echo --- CHECKING ACCOUNTS ---
net user | findstr /i "bolt cirrus flurry dolphin"

echo.
echo --- CHECKING STARTUP FOLDER ---
dir "%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup" | findstr /i "bolt cirrus flurry guardian"
dir "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Startup" | findstr /i "bolt cirrus flurry guardian"

echo.
echo [%date% %time%] ThunderStorm hunt complete!
goto end

:cleanup
echo.
echo ================================================
echo THUNDERSTORM CLEANUP - WINDOWS
echo ================================================

echo [%date% %time%] Starting ThunderStorm cleanup...

echo Stopping suspicious processes...
taskkill /F /IM bolt.exe 2>nul
taskkill /F /IM cirrus.exe 2>nul
taskkill /F /IM flurry.exe 2>nul
taskkill /F /IM guardian.exe 2>nul
taskkill /F /IM doppler.exe 2>nul
taskkill /F /IM dolphin.exe 2>nul

echo Removing suspicious files...
del /F /Q "C:\temp\bolt.exe" 2>nul
del /F /Q "C:\temp\cirrus.exe" 2>nul
del /F /Q "C:\temp\flurry.exe" 2>nul
del /F /Q "C:\temp\guardian.exe" 2>nul
del /F /Q "C:\Windows\Temp\bolt.exe" 2>nul
del /F /Q "C:\Windows\Temp\cirrus.exe" 2>nul
del /F /Q "C:\ProgramData\bolt.exe" 2>nul
del /F /Q "C:\ProgramData\cirrus.exe" 2>nul

echo Removing dolphin malware...
del /F /Q "C:\Windows\System32\dolphin.exe" 2>nul
del /F /Q "C:\temp\dolphin.exe" 2>nul

echo Clearing temp directories...
del /F /Q "C:\temp\*" 2>nul
del /F /Q "%TEMP%\*" 2>nul

echo Checking for registry persistence...
reg delete "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Run" /v "bolt" /f 2>nul
reg delete "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Run" /v "cirrus" /f 2>nul
reg delete "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" /v "bolt" /f 2>nul
reg delete "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" /v "cirrus" /f 2>nul

echo [%date% %time%] Cleanup complete!
goto end

:quickcheck
echo.
echo ================================================
echo QUICK SYSTEM CHECK - WINDOWS
echo ================================================

echo [%date% %time%] Quick system check...

echo.
echo --- SYSTEM INFO ---
systeminfo | findstr /B "OS Name OS Version Total Physical Memory"

echo.
echo --- NETWORK INFO ---
ipconfig | findstr "IPv4"

echo.
echo --- LISTENING PORTS ---
netstat -an | findstr "LISTENING"

echo.
echo --- RUNNING PROCESSES (top 10 by memory) ---
wmic process get name,processid,workingsetsize /format:csv | findstr /v "Node,Name,ProcessId,WorkingSetSize" | sort /R /+3 | head -10

echo.
echo --- SUSPICIOUS ACTIVITY CHECK ---
tasklist | findstr /i "bolt cirrus flurry guardian" >nul
if %errorlevel% equ 0 (
    echo WARNING: Suspicious processes found!
    tasklist | findstr /i "bolt cirrus flurry guardian"
) else (
    echo No suspicious processes detected.
)

netstat -an | findstr ":8080 :8443 :9000 :9001 :4444 :1337" >nul
if %errorlevel% equ 0 (
    echo WARNING: Suspicious network connections found!
    netstat -an | findstr ":8080 :8443 :9000 :9001 :4444 :1337"
) else (
    echo No suspicious network connections detected.
)

echo.
echo [%date% %time%] Quick check complete!
goto end

:end
echo.
echo Windows Defense Toolkit complete. 