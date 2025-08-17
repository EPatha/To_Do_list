#!/usr/bin/env python3
"""
Jarvis AI - Simplified Version for Testing
"""

print("🚀 Starting Jarvis AI...")

try:
    print("📦 Importing modules...")
    import asyncio
    import sys
    from modules.stt import SpeechToText
    from modules.llm import LLMHandler
    from modules.command_parser import CommandParser
    from modules.todo_manager import TodoManager
    from modules.tts import TextToSpeech
    print("✅ All imports successful")

    async def demo():
        print("\n🤖 Initializing Jarvis AI...")
        
        # Initialize components
        stt = SpeechToText()
        llm = LLMHandler()
        parser = CommandParser()
        todo_manager = TodoManager()
        tts = TextToSpeech()
        
        print("✅ Jarvis AI initialized successfully!")
        
        # Demo interaction
        print("\n🎯 Demo interaction:")
        
        # Simulate voice input
        user_input = "tambah task belajar Python"
        print(f"👤 User (simulated): {user_input}")
        
        # Process with LLM
        processed_command = await llm.process(user_input)
        print(f"🧠 LLM processed: {processed_command}")
        
        # Execute command
        result = await parser.parse_and_execute(processed_command, todo_manager)
        print(f"🤖 Jarvis: {result}")
        
        # TTS response
        await tts.speak(result)
        
        # List tasks
        print("\n📋 Current tasks:")
        tasks = await todo_manager.get_all_tasks()
        for task in tasks:
            print(f"  - {task['id']}: {task['text']}")
        
        print("\n🎉 Demo completed successfully!")
        print("\n💡 For full interactive mode, run: python main.py")

    # Run demo
    asyncio.run(demo())

except Exception as e:
    print(f"❌ Error: {e}")
    import traceback
    traceback.print_exc()
    sys.exit(1)

print("\n👋 Jarvis AI demo finished.")
