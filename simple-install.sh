#!/bin/bash

# Simple Laravel Installer with Voice Recognition
# Minimal setup script untuk Laravel To-Do List dengan fitur Voice Recognition

echo "🚀 Laravel To-Do List Setup (with Voice Recognition)"
echo "===================================================="

# Cek requirements
if ! command -v php &> /dev/null; then
    echo "❌ PHP tidak terinstall"
    exit 1
fi

if ! command -v composer &> /dev/null; then
    echo "❌ Composer tidak terinstall" 
    exit 1
fi

echo "✅ Installing dependencies..."
composer install

echo "✅ Setting up environment..."
[ ! -f .env ] && cp .env.example .env
php artisan key:generate

echo "✅ Setting up database..."
[ ! -f database/database.sqlite ] && touch database/database.sqlite
php artisan migrate

echo "✅ Setting up voice recognition assets..."
[ ! -d public/js ] && mkdir -p public/js

echo "🎉 Setup complete!"
echo ""
echo "📋 Available options:"
echo "  • Laravel server: php artisan serve"
echo "  • Voice demo: open voice-demo.html"
echo ""
echo "🎤 Voice commands:"
echo "  • 'Tambah [task name]' - Add new task"
echo "  • 'Selesai [task name]' - Mark as complete"
echo "  • 'Hapus [task name]' - Delete task"
echo "  • 'Bantuan' - Show help"
