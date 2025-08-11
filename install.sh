#!/bin/bash

# Laravel To-Do List Project Installer
# Script untuk setup dan menjalankan proyek Laravel

echo "🚀 Laravel To-Do List Project Installer"
echo "========================================"

# Warna untuk output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Fungsi untuk menampilkan pesan sukses
success() {
    echo -e "${GREEN}✅ $1${NC}"
}

# Fungsi untuk menampilkan pesan error
error() {
    echo -e "${RED}❌ $1${NC}"
}

# Fungsi untuk menampilkan pesan info
info() {
    echo -e "${BLUE}ℹ️  $1${NC}"
}

# Fungsi untuk menampilkan pesan warning
warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

# Cek apakah PHP terinstall
check_php() {
    if ! command -v php &> /dev/null; then
        error "PHP tidak terinstall. Silakan install PHP terlebih dahulu."
        exit 1
    fi
    
    PHP_VERSION=$(php -v | head -n1 | cut -d' ' -f2)
    success "PHP terdeteksi: $PHP_VERSION"
}

# Cek apakah Composer terinstall
check_composer() {
    if ! command -v composer &> /dev/null; then
        error "Composer tidak terinstall. Silakan install Composer terlebih dahulu."
        echo "Download dari: https://getcomposer.org/download/"
        exit 1
    fi
    
    COMPOSER_VERSION=$(composer --version | cut -d' ' -f3)
    success "Composer terdeteksi: $COMPOSER_VERSION"
}

# Cek apakah Node.js terinstall
check_node() {
    if ! command -v node &> /dev/null; then
        warning "Node.js tidak terinstall. Frontend assets tidak akan bisa dikompilasi."
        echo "Download dari: https://nodejs.org/"
        return 1
    fi
    
    NODE_VERSION=$(node -v)
    success "Node.js terdeteksi: $NODE_VERSION"
    return 0
}

# Install dependencies PHP
install_php_dependencies() {
    info "Installing PHP dependencies..."
    if composer install; then
        success "PHP dependencies berhasil diinstall"
    else
        error "Gagal menginstall PHP dependencies"
        exit 1
    fi
}

# Install dependencies Node.js
install_node_dependencies() {
    if check_node; then
        info "Installing Node.js dependencies..."
        if npm install; then
            success "Node.js dependencies berhasil diinstall"
        else
            error "Gagal menginstall Node.js dependencies"
        fi
    fi
}

# Setup environment file
setup_env() {
    if [ ! -f .env ]; then
        info "Membuat file .env..."
        if cp .env.example .env; then
            success "File .env berhasil dibuat"
        else
            error "Gagal membuat file .env"
            exit 1
        fi
    else
        success "File .env sudah ada"
    fi
}

# Generate application key
generate_key() {
    info "Generating application key..."
    if php artisan key:generate; then
        success "Application key berhasil di-generate"
    else
        error "Gagal generate application key"
        exit 1
    fi
}

# Setup database
setup_database() {
    info "Setting up database..."
    
    # Buat file database SQLite jika belum ada
    if [ ! -f database/database.sqlite ]; then
        touch database/database.sqlite
        success "Database SQLite berhasil dibuat"
    else
        success "Database SQLite sudah ada"
    fi
    
    # Jalankan migration
    info "Running database migrations..."
    if php artisan migrate --force; then
        success "Database migrations berhasil dijalankan"
    else
        error "Gagal menjalankan database migrations"
        exit 1
    fi
}

# Build frontend assets
build_assets() {
    if check_node; then
        info "Building frontend assets..."
        if npm run build; then
            success "Frontend assets berhasil di-build"
        else
            warning "Gagal build frontend assets, tapi server masih bisa jalan"
        fi
    fi
}

# Fungsi utama installer
main() {
    echo
    info "Memulai proses instalasi..."
    echo
    
    # Cek requirements
    check_php
    check_composer
    
    # Install dependencies
    install_php_dependencies
    install_node_dependencies
    
    # Setup aplikasi
    setup_env
    generate_key
    setup_database
    build_assets
    
    echo
    success "🎉 Instalasi selesai!"
    echo
    info "Untuk menjalankan server, gunakan:"
    echo "  ./start.sh"
    echo
    info "Atau jalankan manual:"
    echo "  php artisan serve"
    echo
}

# Jalankan installer
main
