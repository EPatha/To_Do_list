"""Command Parser Module"""
import asyncio

class CommandParser:
    def __init__(self):
        print("🔄 Command Parser initialized")

    async def parse_and_execute(self, llm_result, todo_manager):
        """Parse LLM result and execute command"""
        intent = llm_result.get("intent", "UNKNOWN")
        parameters = llm_result.get("parameters", {})
        confidence = llm_result.get("confidence", 0.0)
        
        if confidence < 0.5:
            return "Maaf, saya tidak yakin dengan perintah Anda."
        
        try:
            if intent == "ADD_TASK":
                return await self._handle_add_task(parameters, todo_manager)
            elif intent == "LIST_TASKS":
                return await self._handle_list_tasks(parameters, todo_manager)
            elif intent == "DELETE_TASK":
                return await self._handle_delete_task(parameters, todo_manager)
            else:
                return "Maaf, saya belum bisa memahami perintah tersebut."
        except Exception as e:
            return f"Terjadi kesalahan: {str(e)}"

    async def _handle_add_task(self, parameters, todo_manager):
        """Handle add task command"""
        task_text = parameters.get("task_text", "").strip()
        if not task_text:
            return "Maaf, saya tidak mendengar nama task."
        
        task_id = await todo_manager.add_task(text=task_text)
        if task_id:
            return f"Task '{task_text}' berhasil ditambahkan."
        return "Gagal menambahkan task."

    async def _handle_list_tasks(self, parameters, todo_manager):
        """Handle list tasks command"""
        tasks = await todo_manager.get_all_tasks()
        if not tasks:
            return "Anda belum memiliki task apapun."
        
        task_list = []
        for task in tasks:
            status = "selesai" if task["completed"] else "belum selesai"
            task_list.append(f"{task['id']}. {task['text']} - {status}")
        
        return f"Anda memiliki {len(tasks)} task: " + ", ".join(task_list)

    async def _handle_delete_task(self, parameters, todo_manager):
        """Handle delete task command"""
        task_id = parameters.get("task_id")
        if not task_id:
            return "Sebutkan nomor task yang akan dihapus."
        
        success = await todo_manager.delete_task(task_id)
        if success:
            return f"Task nomor {task_id} telah dihapus."
        return f"Tidak dapat menemukan task nomor {task_id}."
