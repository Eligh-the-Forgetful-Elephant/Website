@echo off
echo ========================================
echo Enhanced Desktop Goose - Windows Compilation
echo ========================================
echo.

echo Checking for Visual Studio Build Tools...
where msbuild >nul 2>&1
if %errorlevel% neq 0 (
    echo ERROR: MSBuild not found!
    echo Please install Visual Studio Build Tools or Visual Studio
    echo Download from: https://visualstudio.microsoft.com/downloads/
    pause
    exit /b 1
)

echo Building Enhanced Desktop Goose...
echo.

REM Build the solution
msbuild GooseDesktop.sln /p:Configuration=Release /p:Platform=AnyCPU /verbosity:minimal

if %errorlevel% neq 0 (
    echo.
    echo ERROR: Build failed!
    echo Please check the error messages above.
    pause
    exit /b 1
)

echo.
echo Build successful!
echo.

REM Copy configuration file to output directory
echo Copying configuration file...
copy config.goos bin\Release\ >nul

REM Copy assets to output directory
echo Copying assets...
if exist "bin\Debug\Assets" (
    xcopy "bin\Debug\Assets" "bin\Release\Assets\" /E /I /Y >nul
)

echo.
echo ========================================
echo Build Complete!
echo ========================================
echo.
echo Enhanced Desktop Goose executable created at:
echo bin\Release\GooseDesktop.exe
echo.
echo Configuration file: bin\Release\config.goos
echo.
echo To run the enhanced goose:
echo 1. Navigate to bin\Release\
echo 2. Run: GooseDesktop.exe
echo.
echo The enhanced features are enabled by default:
echo - File operations: ENABLED
echo - System monitoring: ENABLED  
echo - Network communication: ENABLED
echo - Registry access: ENABLED
echo - Process monitoring: ENABLED
echo.
echo Data will be collected to: %USERPROFILE%\Desktop\goose_data.txt
echo.
pause 