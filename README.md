# Voice-Enabled Todo List Application

## Overview
A modern Todo List application with voice input capability, developed by Ephesians Prismaranatha. This application allows users to manage their tasks through both traditional text input and voice commands, built on top of the Laravel framework.

## Features
- ✅ Create new tasks using voice commands or text input
- 📝 Edit existing tasks
- ✔️ Mark tasks as complete
- 🗑️ Delete tasks
- 🎤 Voice command support (Indonesian & English)
- 📱 Responsive design with TailwindCSS
- ⏰ Task management with real-time updates
- 📊 Task completion tracking
- 🚀 Easy installation with automated scripts

## Technology Stack
- **Backend**: Laravel 12.x
- **Database**: SQLite
- **Frontend**: TailwindCSS, Blade Templates
- **Voice Recognition**: Web Speech API
- **Runtime**: PHP 8.2+
- **Package Manager**: Composer, npm

## Quick Installation

### Option 1: Automated Installer (Recommended)
```bash
# Clone repository
git clone https://github.com/EPatha/To_Do_list.git
cd To_Do_list/laravel-version

# Run installer
./simple-install.sh      # macOS/Linux
# OR
install.bat              # Windows

# Start server
php artisan serve
```

### Option 2: Manual Installation
```bash
# 1. Clone repository
git clone https://github.com/EPatha/To_Do_list.git
cd To_Do_list/laravel-version

# 2. Install dependencies
composer install

# 3. Set up environment
cp .env.example .env
php artisan key:generate

# 4. Create SQLite database
touch database/database.sqlite
php artisan migrate

# 5. Start development server
php artisan serve
```

### Option 3: Quick Demo
```bash
# For testing voice recognition without Laravel setup
open voice-demo.html
```

## Voice Commands
The application supports voice commands in **Indonesian** and **English**:

### Indonesian Commands:
- **"Tambah [nama task]"** - Membuat task baru
- **"Selesai [nama task]"** - Menandai task selesai
- **"Hapus [nama task]"** - Menghapus task
- **"Bersihkan semua"** - Menghapus semua task
- **"Bantuan"** - Menampilkan help

### English Commands:
- **"Add [task name]"** - Creates a new task
- **"Complete [task name]"** - Marks task as complete
- **"Delete [task name]"** - Removes a task
- **"Clear all"** - Removes all tasks
- **"Help"** - Shows help information

### Usage Examples:
```
"Tambah belajar JavaScript"
"Add meeting with client"
"Selesai belajar"
"Complete meeting"
"Hapus JavaScript"
"Delete meeting"
```

## Browser Support
- ✅ **Chrome** (Recommended)
- ✅ **Microsoft Edge**
- ⚠️ **Safari** (Limited support)
- ❌ **Firefox** (Not supported)

## Available Scripts

### Installer Scripts:
- `./simple-install.sh` - Minimal setup (macOS/Linux)
- `./install.sh` - Full featured installer (macOS/Linux)
- `install.bat` - Windows installer
- `./quickstart.sh` - One-command setup and run

### Server Scripts:
- `./start.sh` - Start Laravel server (macOS/Linux)
- `start.bat` - Start Laravel server (Windows)
- `make serve` - Using Makefile

### Development Scripts:
```bash
# Start with Vite dev server
./start.sh --dev

# Custom port
./start.sh --port 3000

# Allow external connections
./start.sh --host 0.0.0.0
```

## Project Structure
```
laravel-version/
├── app/
│   ├── Http/Controllers/
│   │   └── TodoController.php
│   └── Models/
│       └── Todo.php
├── resources/
│   ├── views/todos/
│   │   └── index.blade.php
│   └── js/
│       └── voice-recognition.js
├── public/js/
│   └── voice-recognition.js
├── database/
│   ├── migrations/
│   └── database.sqlite
├── voice-demo.html
├── simple-install.sh
├── start.sh
└── VOICE_RECOGNITION.md
```

## Documentation
- 📖 **[Voice Recognition Guide](VOICE_RECOGNITION.md)** - Detailed voice features documentation
- 📖 **[Installation Guide](INSTALLER_README.md)** - Complete installation instructions
- 🔧 **[Makefile Commands](Makefile)** - Available make commands

## Contributing
1. Fork the project
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## Developer
**Ephesians Prismaranatha**
- GitHub: [@EPatha](https://github.com/EPatha)
- Project: [To_Do_list](https://github.com/EPatha/To_Do_list)

## About Laravel
This project is built on Laravel, a web application framework with expressive, elegant syntax. Laravel is accessible, powerful, and provides tools required for large, robust applications.

Learn more about Laravel:
- [Laravel Documentation](https://laravel.com/docs)
- [Laravel Bootcamp](https://bootcamp.laravel.com)
- [Laracasts](https://laracasts.com)

## License
This project is open-sourced software licensed under the [MIT license](https://opensource.org/licenses/MIT).
