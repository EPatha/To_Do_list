#!/usr/bin/env python3
"""Jarvis AI Setup Script"""
import os
import sys
import subprocess

def install_dependencies():
    """Install Python dependencies"""
    print("📦 Installing dependencies...")
    try:
        subprocess.run([sys.executable, "-m", "pip", "install", "-r", "requirements.txt"], check=True)
        print("✅ Dependencies installed")
        return True
    except subprocess.CalledProcessError as e:
        print(f"❌ Failed to install dependencies: {e}")
        return False

def create_directories():
    """Create necessary directories"""
    print("📁 Creating directories...")
    directories = ["models", "database", "logs"]
    for directory in directories:
        os.makedirs(directory, exist_ok=True)
    print("✅ Directories created")

def main():
    """Main setup function"""
    print("🤖 Jarvis AI Setup")
    print("==================")
    
    create_directories()
    
    if install_dependencies():
        print("\n🎉 Setup completed successfully!")
        print("\nYou can now run Jarvis with:")
        print("  python main.py")
        return True
    else:
        print("\n❌ Setup failed.")
        return False

if __name__ == "__main__":
    success = main()
    sys.exit(0 if success else 1)
