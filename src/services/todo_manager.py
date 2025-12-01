"""Todo Manager Module"""
import asyncio
import sqlite3
import os
from datetime import datetime

class TodoManager:
    def __init__(self, db_path="database/todo.db"):
        self.db_path = db_path
        print("📝 Initializing Todo Manager...")
        asyncio.create_task(self._init_database())

    async def _init_database(self):
        """Initialize SQLite database"""
        try:
            os.makedirs(os.path.dirname(self.db_path), exist_ok=True)
            
            conn = sqlite3.connect(self.db_path)
            cursor = conn.cursor()
            
            cursor.execute("""
                CREATE TABLE IF NOT EXISTS todos (
                    id INTEGER PRIMARY KEY AUTOINCREMENT,
                    text TEXT NOT NULL,
                    completed BOOLEAN DEFAULT FALSE,
                    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
                )
            """)
            
            conn.commit()
            conn.close()
            print("✅ Database initialized")
        except Exception as e:
            print(f"❌ Database error: {e}")

    async def add_task(self, text, due_date=None, priority="normal"):
        """Add new task"""
        try:
            conn = sqlite3.connect(self.db_path)
            cursor = conn.cursor()
            
            cursor.execute("INSERT INTO todos (text) VALUES (?)", (text,))
            task_id = cursor.lastrowid
            
            conn.commit()
            conn.close()
            return task_id
        except Exception as e:
            print(f"❌ Add task error: {e}")
            return None

    async def get_all_tasks(self):
        """Get all tasks"""
        try:
            conn = sqlite3.connect(self.db_path)
            cursor = conn.cursor()
            
            cursor.execute("SELECT * FROM todos ORDER BY created_at DESC")
            rows = cursor.fetchall()
            
            tasks = []
            for row in rows:
                tasks.append({
                    "id": row[0],
                    "text": row[1], 
                    "completed": bool(row[2]),
                    "created_at": row[3]
                })
            
            conn.close()
            return tasks
        except Exception as e:
            print(f"❌ Get tasks error: {e}")
            return []

    async def delete_task(self, task_id):
        """Delete task"""
        try:
            conn = sqlite3.connect(self.db_path)
            cursor = conn.cursor()
            
            cursor.execute("DELETE FROM todos WHERE id = ?", (task_id,))
            success = cursor.rowcount > 0
            
            conn.commit()
            conn.close()
            return success
        except Exception as e:
            print(f"❌ Delete task error: {e}")
            return False

    async def complete_task(self, task_id):
        """Mark task as completed"""
        try:
            conn = sqlite3.connect(self.db_path)
            cursor = conn.cursor()
            
            cursor.execute("UPDATE todos SET completed = TRUE WHERE id = ?", (task_id,))
            success = cursor.rowcount > 0
            
            conn.commit()
            conn.close()
            return success
        except Exception as e:
            print(f"❌ Complete task error: {e}")
            return False
