# Laravel To-Do List Project

Proyek aplikasi To-Do List yang dibuat dengan Laravel framework.

## 📋 Requirements

- PHP >= 8.2
- Composer
- Node.js & npm (opsional, untuk kompilasi frontend assets)
- SQLite (sudah termasuk di PHP)

## 🚀 Quick Start

### Untuk macOS/Linux:

1. **Install dan Setup:**
   ```bash
   chmod +x install.sh start.sh
   ./install.sh
   ```

2. **Jalankan Server:**
   ```bash
   ./start.sh
   ```

### Untuk Windows:

1. **Install dan Setup:**
   ```cmd
   install.bat
   ```

2. **Jalankan Server:**
   ```cmd
   start.bat
   ```

## 📖 Manual Installation

Jika Anda ingin melakukan instalasi manual:

```bash
# 1. Install PHP dependencies
composer install

# 2. Copy environment file
cp .env.example .env

# 3. Generate application key
php artisan key:generate

# 4. Create database file (SQLite)
touch database/database.sqlite

# 5. Run migrations
php artisan migrate

# 6. Install Node dependencies (opsional)
npm install

# 7. Build assets (opsional)
npm run build

# 8. Start development server
php artisan serve
```

## 🛠️ Available Scripts

### Shell Scripts (macOS/Linux)

- `./install.sh` - Install semua dependencies dan setup aplikasi
- `./start.sh` - Jalankan development server
- `./start.sh --help` - Lihat opsi yang tersedia

**Opsi untuk start.sh:**
```bash
./start.sh --port 3000          # Custom port
./start.sh --host 0.0.0.0       # Allow external connections
./start.sh --dev                # Start dengan Vite dev server
```

### Batch Scripts (Windows)

- `install.bat` - Install semua dependencies dan setup aplikasi
- `start.bat` - Jalankan development server

**Opsi untuk start.bat:**
```cmd
start.bat --port 3000           # Custom port
start.bat --host 0.0.0.0        # Allow external connections
start.bat --dev                 # Start dengan Vite dev server
```

## 🌐 Akses Aplikasi

Setelah server berjalan, buka browser dan akses:
- **Default:** http://127.0.0.1:8000
- **Custom port:** http://127.0.0.1:[PORT]

## 🔧 Development

### Frontend Development

Untuk development frontend dengan hot reload:

```bash
# macOS/Linux
./start.sh --dev

# Windows
start.bat --dev
```

### Database

Aplikasi ini menggunakan SQLite sebagai database default. File database berada di `database/database.sqlite`.

Untuk reset database:
```bash
php artisan migrate:fresh
```

### Artisan Commands

```bash
# Lihat semua routes
php artisan route:list

# Clear cache
php artisan cache:clear
php artisan config:clear
php artisan view:clear

# Generate new migration
php artisan make:migration create_example_table

# Generate new model
php artisan make:model Example

# Generate new controller
php artisan make:controller ExampleController
```

## 🛠️ Troubleshooting

### Port sudah digunakan
```bash
# macOS/Linux
./start.sh --port 3000

# Windows
start.bat --port 3000
```

### Permission denied (macOS/Linux)
```bash
chmod +x install.sh start.sh
```

### Composer dependencies error
```bash
composer install --no-dev --optimize-autoloader
```

### Node.js dependencies error
```bash
rm -rf node_modules package-lock.json
npm install
```

## 📝 Features

- ✅ CRUD operations untuk To-Do items
- ✅ Responsive design
- ✅ SQLite database
- ✅ Laravel Blade templating
- ✅ Bootstrap/Tailwind CSS styling
- ✅ Automated setup scripts

## 🤝 Contributing

1. Fork the project
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📄 License

This project is open-sourced software licensed under the [MIT license](https://opensource.org/licenses/MIT).
