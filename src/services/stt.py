"""Speech-to-Text Module using Vosk"""
import asyncio
import json
import queue
import threading

class SpeechToText:
    def __init__(self):
        print("🎤 Initializing Speech-to-Text...")
        print("✅ STT initialized")

    async def listen(self, timeout=10):
        """Listen for voice input and convert to text"""
        try:
            # Simulation for demo - replace with actual Vosk implementation
            await asyncio.sleep(2)
            return "Tambah task belajar Python"
        except Exception as e:
            print(f"❌ STT Error: {e}")
            return None

    def stop_listening(self):
        """Stop listening for audio"""
        pass
