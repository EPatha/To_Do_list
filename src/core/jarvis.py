"""
Jarvis AI Main Class
Orchestrates all AI components for voice-controlled task management
"""

import asyncio
import signal
import sys
from typing import Optional

from ..services.stt import SpeechToText
from ..services.llm import LLMHandler
from ..services.command_parser import CommandParser
from ..services.todo_manager import TodoManager
from ..services.tts import TextToSpeech
from ..utils.logger import setup_logger


class JarvisAI:
    """
    Main Jarvis AI class that coordinates all components
    """
    
    def __init__(self):
        """Initialize all Jarvis AI components"""
        self.logger = setup_logger(__name__)
        self.logger.info("🤖 Initializing Jarvis AI...")
        
        # Initialize AI components
        self.stt = SpeechToText()
        self.llm = LLMHandler()
        self.parser = CommandParser()
        self.todo_manager = TodoManager()
        self.tts = TextToSpeech()
        
        self.running = False
        self.logger.info("✅ Jarvis AI initialized successfully!")

    async def start(self):
        """Start Jarvis AI main loop"""
        self.running = True
        
        # Welcome message
        welcome_msg = "Halo! Saya Jarvis, asisten AI Anda. Saya siap membantu mengelola task Anda!"
        self.logger.info(f"🤖 Jarvis: {welcome_msg}")
        await self.tts.speak(welcome_msg)
        
        self.logger.info("🎤 Listening for voice commands... (Press Ctrl+C to exit)")
        
        while self.running:
            try:
                # Listen for voice input
                self.logger.info("🎤 Listening...")
                audio_text = await self.stt.listen()
                
                if audio_text:
                    self.logger.info(f"👤 You: {audio_text}")
                    
                    # Process command with LLM
                    processed_command = await self.llm.process(audio_text)
                    
                    # Parse and execute command
                    result = await self.parser.parse_and_execute(
                        processed_command, self.todo_manager
                    )
                    
                    # Respond with voice
                    self.logger.info(f"🤖 Jarvis: {result}")
                    await self.tts.speak(result)
                
                # Small delay to prevent excessive CPU usage
                await asyncio.sleep(0.1)
                
            except KeyboardInterrupt:
                break
            except Exception as e:
                error_msg = f"Maaf, terjadi kesalahan: {str(e)}"
                self.logger.error(f"❌ Error: {error_msg}")
                await self.tts.speak(error_msg)

    def stop(self):
        """Stop Jarvis AI gracefully"""
        self.running = False
        self.logger.info("👋 Jarvis AI shutdown complete. Goodbye!")

    def setup_signal_handlers(self):
        """Setup signal handlers for graceful shutdown"""
        def signal_handler(signum, frame):
            self.logger.info("\n\n🛑 Shutdown signal received...")
            self.stop()
            sys.exit(0)
        
        signal.signal(signal.SIGINT, signal_handler)
        signal.signal(signal.SIGTERM, signal_handler)
