# 📝 CHANGELOG

All notable changes to this project will be documented in this file.

## [2.0.0] - 2025-12-01

### 🎉 Major Restructure

Complete project restructuring for better organization and maintainability.

### ✨ Added

- **New folder structure** with `src/` package
  - `src/core/` - Core business logic
  - `src/services/` - AI services and components
  - `src/utils/` - Utility functions
- **JarvisAI class** in `src/core/jarvis.py` - Main orchestrator
- **Logger utility** in `src/utils/logger.py` - Structured logging
- **Documentation files**:
  - `STRUCTURE.md` - Detailed folder structure guide
  - `SUMMARY.md` - Summary of changes
  - `CHANGELOG.md` - This file
  - `docs/README.md` - Documentation hub

### 🔄 Changed

- **main.py** - Refactored as clean entry point
  - Removed debug code
  - Clean imports from `src/`
  - Better error handling
- **README.md** - Updated with new structure
  - Professional formatting
  - Clear installation guide
  - Better documentation
- **Module organization** - Moved from `modules/` to `src/services/`
  - `stt.py` - Speech-to-Text
  - `llm.py` - LLM Handler
  - `tts.py` - Text-to-Speech
  - `command_parser.py` - Command Parser
  - `todo_manager.py` - Todo Manager

### 📦 Structure

```
Before (v1.x):
modules/
  ├── stt.py
  ├── llm.py
  └── ...
  
After (v2.0):
src/
  ├── core/
  │   └── jarvis.py
  ├── services/
  │   ├── stt.py
  │   ├── llm.py
  │   └── ...
  └── utils/
      └── logger.py
```

### 🗂️ Moved

- Test files to `tests/` directory
- Old files backed up with `.old` extension

### 🔧 Technical

- All imports now use `src.` prefix
- Relative imports within `src/` package
- Better separation of concerns
- Modular architecture

---

## [1.0.0] - 2025-08-15

### Initial Release

- Basic Jarvis AI functionality
- Voice-controlled todo list
- LLM integration
- SQLite database
- Text-to-Speech responses

---

## Version Format

This project follows [Semantic Versioning](https://semver.org/):
- **MAJOR** version for incompatible API changes
- **MINOR** version for backwards-compatible functionality additions
- **PATCH** version for backwards-compatible bug fixes
