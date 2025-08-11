@echo off
REM Laravel To-Do List Server Starter for Windows
REM Script untuk menjalankan development server

echo 🚀 Starting Laravel To-Do List Server
echo =====================================

REM Default values
set HOST=127.0.0.1
set PORT=8000
set DEV_MODE=false

REM Parse command line arguments
:parse_args
if "%1"=="" goto start_server
if "%1"=="--host" (
    set HOST=%2
    shift
    shift
    goto parse_args
)
if "%1"=="--port" (
    set PORT=%2
    shift
    shift
    goto parse_args
)
if "%1"=="-p" (
    set PORT=%2
    shift
    shift
    goto parse_args
)
if "%1"=="--dev" (
    set DEV_MODE=true
    shift
    goto parse_args
)
if "%1"=="-d" (
    set DEV_MODE=true
    shift
    goto parse_args
)
if "%1"=="--help" goto show_help
if "%1"=="-h" goto show_help

echo ❌ Unknown option: %1
echo Use --help for usage information
pause
exit /b 1

:show_help
echo Usage: %0 [OPTIONS]
echo.
echo Options:
echo   --host HOST     Set host (default: 127.0.0.1)
echo   --port PORT     Set port (default: 8000)
echo   --dev, -d       Run in development mode with Vite
echo   --help, -h      Show this help message
echo.
echo Examples:
echo   %0                    # Start server on default host:port
echo   %0 --port 3000       # Start server on port 3000
echo   %0 --dev             # Start with Vite dev server
echo   %0 --host 0.0.0.0    # Allow external connections
pause
exit /b 0

:start_server
REM Cek apakah di direktori Laravel
if not exist artisan (
    echo ❌ File artisan tidak ditemukan. Pastikan Anda berada di direktori root Laravel.
    pause
    exit /b 1
)

REM Cek apakah .env ada
if not exist .env (
    echo ❌ File .env tidak ditemukan. Jalankan install.bat terlebih dahulu.
    pause
    exit /b 1
)

REM Cek apakah vendor directory ada
if not exist vendor (
    echo ❌ Directory vendor tidak ditemukan. Jalankan install.bat terlebih dahulu.
    pause
    exit /b 1
)

echo.
echo ℹ️ Configuration:
echo   Host: %HOST%
echo   Port: %PORT%
echo   Development mode: %DEV_MODE%
echo.

REM Start Vite jika dalam dev mode
if "%DEV_MODE%"=="true" (
    node -v >nul 2>&1
    if %errorlevel% equ 0 (
        echo ℹ️ Starting Vite development server...
        start "Vite Dev Server" cmd /c "npm run dev"
        timeout /t 2 /nobreak >nul
        echo ✅ Vite dev server started
        echo.
    ) else (
        echo ❌ npm tidak ditemukan. Vite dev server tidak bisa dijalankan.
    )
)

REM Start Laravel server
echo ℹ️ Starting Laravel development server...
echo.
echo ℹ️ Server akan berjalan di: http://%HOST%:%PORT%
echo.
echo ✅ Tekan Ctrl+C untuk menghentikan server
echo.

REM Buka browser otomatis
start "" "http://%HOST%:%PORT%" >nul 2>&1

REM Jalankan Laravel server
php artisan serve --host=%HOST% --port=%PORT%

echo.
echo ℹ️ Server dihentikan
pause
