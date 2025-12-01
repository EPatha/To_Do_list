#!/usr/bin/env python3
"""
Jarvis To-Do List AI - Main Entry Point
Voice-enabled AI assistant for local task management

Author: Ephesians Prismaranatha
Version: 1.0.0

Usage:
    python main.py          # Start Jarvis AI in interactive mode
    python main.py --demo   # Run demo mode
    python main.py --test   # Run tests
"""

import asyncio
import sys
from pathlib import Path

# Add src to path for imports
sys.path.insert(0, str(Path(__file__).parent))

from src.core.jarvis import JarvisAI
from src.utils.logger import setup_logger


async def main():
    """
    Main entry point for Jarvis AI
    Initializes and starts the AI assistant
    """
    logger = setup_logger(__name__)
    logger.info("🚀 Starting Jarvis AI...")
    
    try:
        # Create Jarvis AI instance
        jarvis = JarvisAI()
        
        # Setup signal handlers for graceful shutdown
        jarvis.setup_signal_handlers()
        
        # Start the AI assistant
        await jarvis.start()
        
    except KeyboardInterrupt:
        logger.info("\n\n🛑 Shutdown requested by user")
    except Exception as e:
        logger.error(f"❌ Fatal error: {e}")
        import traceback
        traceback.print_exc()
        sys.exit(1)
    finally:
        logger.info("👋 Jarvis AI shutdown complete")


if __name__ == "__main__":
    try:
        asyncio.run(main())
    except KeyboardInterrupt:
        print("\n👋 Goodbye!")
        sys.exit(0)
