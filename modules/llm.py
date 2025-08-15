"""LLM Handler using Ollama"""
import asyncio
import json
import re

class LLMHandler:
    def __init__(self):
        print("🧠 Initializing Local LLM...")
        print("✅ LLM initialized")

    async def process(self, user_input):
        """Process user input with LLM"""
        try:
            # Simple keyword-based parsing for demo
            user_input = user_input.lower()
            
            if any(keyword in user_input for keyword in ["tambah", "buat", "add"]):
                task_text = re.sub(r'(tambah|buat|add)\s+(task\s+)?', '', user_input).strip()
                return {
                    "intent": "ADD_TASK",
                    "parameters": {"task_text": task_text},
                    "confidence": 0.9
                }
            elif any(keyword in user_input for keyword in ["lihat", "list", "tampilkan"]):
                return {
                    "intent": "LIST_TASKS", 
                    "parameters": {},
                    "confidence": 0.9
                }
            elif any(keyword in user_input for keyword in ["hapus", "delete"]):
                numbers = re.findall(r'\d+', user_input)
                task_id = int(numbers[0]) if numbers else None
                return {
                    "intent": "DELETE_TASK",
                    "parameters": {"task_id": task_id},
                    "confidence": 0.8
                }
            else:
                return {
                    "intent": "UNKNOWN",
                    "parameters": {"original_text": user_input},
                    "confidence": 0.3
                }
        except Exception as e:
            print(f"❌ LLM Error: {e}")
            return {"intent": "ERROR", "parameters": {}, "confidence": 0.1}
