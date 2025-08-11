#!/bin/bash

# Quick Start Script - Laravel To-Do List
# Script cepat untuk langsung menjalankan aplikasi

echo "⚡ Laravel To-Do List - Quick Start"
echo "=================================="

# Cek apakah sudah di-setup sebelumnya
if [ ! -f .env ] || [ ! -d vendor ]; then
    echo "🔧 Aplikasi belum di-setup, menjalankan installer..."
    ./install.sh
    if [ $? -ne 0 ]; then
        echo "❌ Instalasi gagal!"
        exit 1
    fi
else
    echo "✅ Aplikasi sudah di-setup sebelumnya"
fi

echo
echo "🚀 Menjalankan server..."
./start.sh
