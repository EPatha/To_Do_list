@echo off
REM Laravel To-Do List Project Installer for Windows
REM Script untuk setup dan menjalankan proyek Laravel

echo 🚀 Laravel To-Do List Project Installer
echo ========================================

REM Cek apakah PHP terinstall
php -v >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ PHP tidak terinstall. Silakan install PHP terlebih dahulu.
    echo Download dari: https://www.php.net/downloads
    pause
    exit /b 1
)
echo ✅ PHP terdeteksi

REM Cek apakah Composer terinstall
composer --version >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ Composer tidak terinstall. Silakan install Composer terlebih dahulu.
    echo Download dari: https://getcomposer.org/download/
    pause
    exit /b 1
)
echo ✅ Composer terdeteksi

REM Cek apakah Node.js terinstall
node -v >nul 2>&1
if %errorlevel% neq 0 (
    echo ⚠️ Node.js tidak terinstall. Frontend assets tidak akan bisa dikompilasi.
    echo Download dari: https://nodejs.org/
    set NODE_AVAILABLE=false
) else (
    echo ✅ Node.js terdeteksi
    set NODE_AVAILABLE=true
)

echo.
echo ℹ️ Installing PHP dependencies...
call composer install
if %errorlevel% neq 0 (
    echo ❌ Gagal menginstall PHP dependencies
    pause
    exit /b 1
)
echo ✅ PHP dependencies berhasil diinstall

REM Install Node.js dependencies jika tersedia
if "%NODE_AVAILABLE%"=="true" (
    echo.
    echo ℹ️ Installing Node.js dependencies...
    call npm install
    if %errorlevel% neq 0 (
        echo ❌ Gagal menginstall Node.js dependencies
    ) else (
        echo ✅ Node.js dependencies berhasil diinstall
    )
)

REM Setup environment file
if not exist .env (
    echo.
    echo ℹ️ Membuat file .env...
    copy .env.example .env >nul
    if %errorlevel% neq 0 (
        echo ❌ Gagal membuat file .env
        pause
        exit /b 1
    )
    echo ✅ File .env berhasil dibuat
) else (
    echo ✅ File .env sudah ada
)

REM Generate application key
echo.
echo ℹ️ Generating application key...
call php artisan key:generate
if %errorlevel% neq 0 (
    echo ❌ Gagal generate application key
    pause
    exit /b 1
)
echo ✅ Application key berhasil di-generate

REM Setup database
echo.
echo ℹ️ Setting up database...

REM Buat file database SQLite jika belum ada
if not exist database\database.sqlite (
    type nul > database\database.sqlite
    echo ✅ Database SQLite berhasil dibuat
) else (
    echo ✅ Database SQLite sudah ada
)

REM Jalankan migration
echo ℹ️ Running database migrations...
call php artisan migrate --force
if %errorlevel% neq 0 (
    echo ❌ Gagal menjalankan database migrations
    pause
    exit /b 1
)
echo ✅ Database migrations berhasil dijalankan

REM Build frontend assets jika Node.js tersedia
if "%NODE_AVAILABLE%"=="true" (
    echo.
    echo ℹ️ Building frontend assets...
    call npm run build
    if %errorlevel% neq 0 (
        echo ⚠️ Gagal build frontend assets, tapi server masih bisa jalan
    ) else (
        echo ✅ Frontend assets berhasil di-build
    )
)

echo.
echo ✅ 🎉 Instalasi selesai!
echo.
echo ℹ️ Untuk menjalankan server, gunakan:
echo   start.bat
echo.
echo ℹ️ Atau jalankan manual:
echo   php artisan serve
echo.
pause
