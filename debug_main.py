#!/usr/bin/env python3
"""
Debug version of main.py
"""

print("🔴 Starting debug_main.py...")

try:

    print("🔴 Step 1: Basic imports...")
    import asyncio
    import signal
    import sys
    print("🔴 Step 1: OK")

    print("🔴 Step 2: Module imports...")
    from modules.stt import SpeechToText
    from modules.llm import LLMHandler
    from modules.command_parser import CommandParser
    from modules.todo_manager import TodoManager
    from modules.tts import TextToSpeech
    from config.settings import *
    print("🔴 Step 2: OK")

    print("🔴 Step 3: Creating JarvisAI class...")
    
    class JarvisAI:
        def __init__(self):
            print("🔴 JarvisAI.__init__ started")
            self.stt = SpeechToText()
            self.llm = LLMHandler()
            self.parser = CommandParser()
            self.todo_manager = TodoManager()
            self.tts = TextToSpeech()
            self.is_running = False
            print("🔴 JarvisAI.__init__ completed")

        async def initialize(self):
            print("🔴 JarvisAI.initialize started")
            await self.todo_manager.initialize()
            print("🔴 JarvisAI.initialize completed")

    print("🔴 Step 3: OK")

    print("🔴 Step 4: Creating main function...")
    
    async def main():
        print("🔴 main() function started")
        jarvis = JarvisAI()
        print("🔴 JarvisAI instance created")
        await jarvis.initialize()
        print("🔴 JarvisAI initialized")
        print("🔴 DEBUG MAIN COMPLETED SUCCESSFULLY!")

    print("🔴 Step 4: OK")

    print("🔴 Step 5: Running main...")
    if __name__ == "__main__":
        print("🔴 In __main__ block")
        asyncio.run(main())
        print("🔴 asyncio.run completed")

    print("🔴 All steps completed!")

except Exception as e:
    print(f"🔴 ERROR: {e}")
    import traceback
    traceback.print_exc()
