#!/usr/bin/env python3
"""Test runner for main.py"""

import subprocess
import sys
import time
import threading

def run_with_timeout():
    try:
        print("🔴 Starting main.py with timeout...")
        
        # Start the process
        process = subprocess.Popen(
            [sys.executable, "main.py"],
            stdout=subprocess.PIPE,
            stderr=subprocess.PIPE,
            text=True
        )
        
        # Wait for 5 seconds
        try:
            stdout, stderr = process.communicate(timeout=5)
            print(f"🔴 STDOUT: {stdout}")
            print(f"🔴 STDERR: {stderr}")
            print(f"🔴 Return code: {process.returncode}")
        except subprocess.TimeoutExpired:
            print("🔴 Process timed out after 5 seconds")
            process.kill()
            stdout, stderr = process.communicate()
            print(f"🔴 STDOUT (after kill): {stdout}")
            print(f"🔴 STDERR (after kill): {stderr}")
            
    except Exception as e:
        print(f"🔴 ERROR: {e}")

if __name__ == "__main__":
    run_with_timeout()
