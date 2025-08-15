"""Configuration Settings for Jarvis AI"""
import os

# LLM Configuration
OLLAMA_URL = "http://localhost:11434"
MODEL_NAME = "llama3"

# Speech-to-Text Configuration
VOSK_MODEL_PATH = "models/vosk"
SAMPLE_RATE = 16000
CHANNELS = 1

# Text-to-Speech Configuration
TTS_ENGINE = "espeak"
PIPER_MODEL_PATH = "models/piper/id_ID-fgl-medium.onnx"
COQUI_MODEL_NAME = "tts_models/id/mai/tacotron2-DDC"

# Database Configuration
DATABASE_PATH = "database/todo.db"

# Voice Recognition Settings
VOICE_TIMEOUT = 10

# Default Messages
WELCOME_MESSAGE = "Halo! Saya Jarvis, asisten AI Anda."
ERROR_MESSAGE = "Maaf, terjadi kesalahan."
