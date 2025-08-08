# Voice-Enabled Todo List Application

## Overview
A modern Todo List application with voice input capability, developed by Ephesians Prismaranatha. This application allows users to manage their tasks through both traditional text input and voice commands.

## Features
- ✅ Create new tasks using voice commands or text input
- 📝 Edit existing tasks
- ✔️ Mark tasks as complete
- 🗑️ Delete tasks
- 🎤 Voice command support
- 📱 Responsive design
- ⏰ Task due dates
- 📊 Task completion tracking

## Technology Stack
- Laravel 10.x
- SQLite Database
- TailwindCSS
- Web Speech API for voice recognition
- PHP 8.x

## Installation
1. Clone the repository:
```bash
git clone https://github.com/EPatha/To_Do_list.git
cd To_Do_list
```

2. Install dependencies:
```bash
composer install
```

3. Set up environment:
```bash
cp .env.example .env
php artisan key:generate
```

4. Create SQLite database:
```bash
touch database/database.sqlite
php artisan migrate
```

5. Start the development server:
```bash
php artisan serve
```

## Voice Commands
The application supports the following voice commands:
- "Add task [task name]" - Creates a new task
- "Complete task [task name]" - Marks a task as complete
- "Delete task [task name]" - Removes a task
- "List tasks" - Shows all tasks

## Developer
Ephesians Prismaranatha
- GitHub: [@EPatha](https://github.com/EPatha)

## License
This project is open-sourced software licensed under the MIT license.
