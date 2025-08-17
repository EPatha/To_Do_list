#!/usr/bin/env python3
"""
Test script untuk Jarvis AI
"""

import asyncio
import sys

# Import at module level
from modules.stt import SpeechToText
from modules.llm import LLMHandler
from modules.command_parser import CommandParser
from modules.todo_manager import TodoManager
from modules.tts import TextToSpeech
from config.settings import *

def main():
    print("🧪 Testing Jarvis AI components...")
    
    try:
        print("✅ All imports successful")
        
        # Test component initialization
        async def test_components():
            print("\n🔧 Testing component initialization...")
            
            stt = SpeechToText()
            llm = LLMHandler()
            parser = CommandParser()
            todo_manager = TodoManager()
            tts = TextToSpeech()
            
            print("✅ All components initialized")
            
            # Test basic functionality
            print("\n🎯 Testing basic functionality...")
            
            # Test LLM processing
            result = await llm.process("tambah task belajar Python")
            print("LLM result:", result)
            
            # Test adding task
            task_id = await todo_manager.add_task("Test task dari script test")
            print("Task added with ID:", task_id)
            
            # Test listing tasks
            tasks = await todo_manager.get_all_tasks()
            print("Current tasks:", len(tasks))
            
            # Test TTS
            await tts.speak("Test berhasil!")
            
            print("\n🎉 All tests passed!")
            return True
        
        # Run async test
        result = asyncio.run(test_components())
        
        if result:
            print("\n✅ Jarvis AI is ready to run!")
            print("Jalankan dengan: python main.py")
        
    except Exception as e:
        print(f"❌ Error: {e}")
        import traceback
        traceback.print_exc()
        return False
    
    return True

if __name__ == "__main__":
    success = main()
    sys.exit(0 if success else 1)
