# Laravel To-Do List Makefile
# Alternative commands untuk menjalankan aplikasi

.PHONY: help install serve setup clean fresh dev

# Default target
help:
	@echo "Laravel To-Do List - Available Commands:"
	@echo ""
	@echo "  make install    - Install semua dependencies"
	@echo "  make setup      - Setup aplikasi (env, key, database)"
	@echo "  make serve      - Jalankan Laravel development server"
	@echo "  make dev        - Jalankan server dengan Vite dev mode"
	@echo "  make fresh      - Reset database dengan fresh migration"
	@echo "  make clean      - Bersihkan cache dan compiled files"
	@echo "  make help       - Tampilkan help ini"
	@echo ""

# Install all dependencies
install:
	@echo "📦 Installing PHP dependencies..."
	composer install
	@if command -v npm >/dev/null 2>&1; then \
		echo "📦 Installing Node.js dependencies..."; \
		npm install; \
	else \
		echo "⚠️  Node.js not found, skipping npm install"; \
	fi

# Setup environment
setup:
	@echo "🔧 Setting up application..."
	@if [ ! -f .env ]; then \
		cp .env.example .env; \
		echo "✅ .env file created"; \
	else \
		echo "✅ .env file already exists"; \
	fi
	php artisan key:generate
	@if [ ! -f database/database.sqlite ]; then \
		touch database/database.sqlite; \
		echo "✅ SQLite database created"; \
	else \
		echo "✅ SQLite database already exists"; \
	fi
	php artisan migrate

# Start Laravel development server
serve:
	@echo "🚀 Starting Laravel development server..."
	@echo "Server will be available at: http://127.0.0.1:8000"
	@echo "Press Ctrl+C to stop the server"
	php artisan serve

# Start with Vite dev server
dev:
	@if command -v npm >/dev/null 2>&1; then \
		echo "🚀 Starting Laravel + Vite development servers..."; \
		npm run serve:dev; \
	else \
		echo "⚠️  Node.js not found, starting Laravel server only..."; \
		make serve; \
	fi

# Fresh database migration
fresh:
	@echo "🗄️  Running fresh database migration..."
	php artisan migrate:fresh

# Clean cache and compiled files
clean:
	@echo "🧹 Cleaning cache and compiled files..."
	php artisan cache:clear
	php artisan config:clear
	php artisan view:clear
	php artisan route:clear
	@if [ -d bootstrap/cache ]; then \
		rm -f bootstrap/cache/*.php; \
		echo "✅ Bootstrap cache cleared"; \
	fi

# Full installation and setup
install-full: install setup
	@if command -v npm >/dev/null 2>&1; then \
		echo "🎨 Building frontend assets..."; \
		npm run build; \
	fi
	@echo ""
	@echo "🎉 Installation complete!"
	@echo ""
	@echo "To start the server, run:"
	@echo "  make serve"
	@echo ""
