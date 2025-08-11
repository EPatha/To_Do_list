#!/bin/bash

# Laravel To-Do List Server Starter
# Script untuk menjalankan development server

echo "🚀 Starting Laravel To-Do List Server"
echo "====================================="

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

# Default values
HOST="127.0.0.1"
PORT="8000"
DEV_MODE=false

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --host)
            HOST="$2"
            shift 2
            ;;
        --port|-p)
            PORT="$2"
            shift 2
            ;;
        --dev|-d)
            DEV_MODE=true
            shift
            ;;
        --help|-h)
            echo "Usage: $0 [OPTIONS]"
            echo ""
            echo "Options:"
            echo "  --host HOST     Set host (default: 127.0.0.1)"
            echo "  --port PORT     Set port (default: 8000)"
            echo "  --dev, -d       Run in development mode with Vite"
            echo "  --help, -h      Show this help message"
            echo ""
            echo "Examples:"
            echo "  $0                    # Start server on default host:port"
            echo "  $0 --port 3000       # Start server on port 3000"
            echo "  $0 --dev             # Start with Vite dev server"
            echo "  $0 --host 0.0.0.0    # Allow external connections"
            exit 0
            ;;
        *)
            error "Unknown option: $1"
            echo "Use --help for usage information"
            exit 1
            ;;
    esac
done

# Cek apakah di direktori Laravel
if [ ! -f artisan ]; then
    error "File artisan tidak ditemukan. Pastikan Anda berada di direktori root Laravel."
    exit 1
fi

# Cek apakah .env ada
if [ ! -f .env ]; then
    error "File .env tidak ditemukan. Jalankan ./install.sh terlebih dahulu."
    exit 1
fi

# Cek apakah vendor directory ada
if [ ! -d vendor ]; then
    error "Directory vendor tidak ditemukan. Jalankan ./install.sh terlebih dahulu."
    exit 1
fi

# Function untuk cleanup saat script dihentikan
cleanup() {
    echo
    info "Menghentikan server..."
    if [ ! -z "$ARTISAN_PID" ]; then
        kill $ARTISAN_PID 2>/dev/null
    fi
    if [ ! -z "$VITE_PID" ] && [ "$DEV_MODE" = true ]; then
        kill $VITE_PID 2>/dev/null
    fi
    success "Server dihentikan"
    exit 0
}

# Set trap untuk menangkap Ctrl+C
trap cleanup SIGINT SIGTERM

# Function untuk menjalankan Vite dev server
start_vite() {
    if command -v npm &> /dev/null; then
        info "Starting Vite development server..."
        npm run dev &
        VITE_PID=$!
        sleep 2
        success "Vite dev server started (PID: $VITE_PID)"
    else
        error "npm tidak ditemukan. Vite dev server tidak bisa dijalankan."
    fi
}

# Function untuk menjalankan Laravel server
start_laravel() {
    info "Starting Laravel development server..."
    echo
    info "Server akan berjalan di: http://$HOST:$PORT"
    echo
    success "Tekan Ctrl+C untuk menghentikan server"
    echo
    
    php artisan serve --host=$HOST --port=$PORT &
    ARTISAN_PID=$!
    
    # Tunggu sebentar untuk memastikan server start
    sleep 2
    
    # Cek apakah server berhasil start
    if kill -0 $ARTISAN_PID 2>/dev/null; then
        success "Laravel server started successfully (PID: $ARTISAN_PID)"
        
        # Jika di macOS, buka browser
        if [[ "$OSTYPE" == "darwin"* ]]; then
            sleep 1
            open "http://$HOST:$PORT" 2>/dev/null || true
        fi
        
        # Tunggu hingga server dihentikan
        wait $ARTISAN_PID
    else
        error "Gagal menjalankan Laravel server"
        exit 1
    fi
}

# Main function
main() {
    echo
    info "Configuration:"
    echo "  Host: $HOST"
    echo "  Port: $PORT"
    echo "  Development mode: $DEV_MODE"
    echo
    
    # Start Vite jika dalam dev mode
    if [ "$DEV_MODE" = true ]; then
        start_vite
        echo
    fi
    
    # Start Laravel server
    start_laravel
}

# Jalankan main function
main
