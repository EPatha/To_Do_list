<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Todo List with Voice Recognition</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <style>
        .voice-button {
            transition: all 0.3s ease;
        }
        .voice-button.listening {
            background: linear-gradient(45deg, #ef4444, #f59e0b);
            animation: pulse 1.5s ease-in-out infinite;
        }
        @keyframes pulse {
            0%, 100% { transform: scale(1); }
            50% { transform: scale(1.05); }
        }
        .voice-status {
            font-size: 0.875rem;
            color: #6b7280;
        }
    </style>
</head>
<body class="bg-gray-100">
    <div class="container mx-auto px-4 py-8">
        <div class="max-w-4xl mx-auto">
            <h1 class="text-3xl font-bold mb-8 text-center">Todo List with Voice Recognition</h1>
            
            <!-- Voice Recognition Controls -->
            <div class="mb-8 text-center">
                <button id="voiceButton" type="button" 
                    class="voice-button px-8 py-4 bg-blue-500 text-white rounded-full hover:bg-blue-600 focus:outline-none focus:ring-2 focus:ring-blue-500 focus:ring-offset-2 shadow-lg">
                    🎤 Voice Control
                </button>
                <div id="voiceStatus" class="voice-status mt-2">Klik untuk berbicara</div>
                <div class="mt-2 text-xs text-gray-500">
                    Katakan: "Tambah [task]", "Selesai [task]", "Hapus [task]", atau "Bantuan"
                </div>
            </div>
            
            <!-- Add Todo Form -->
            <form id="addTodoForm" action="{{ route('todos.store') }}" method="POST" class="mb-8">
                @csrf
                <div class="flex gap-4">
                    <input id="todoInput" type="text" name="title" placeholder="Enter your todo or use voice command" required
                        class="flex-1 px-4 py-2 border rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500">
                    <button type="submit" 
                        class="px-6 py-2 bg-blue-500 text-white rounded-lg hover:bg-blue-600 focus:outline-none focus:ring-2 focus:ring-blue-500">
                        Add Todo
                    </button>
                </div>
            </form>

        <!-- Todo List -->
        <div class="space-y-4">
            @forelse($todos as $todo)
                <div class="todo-item flex items-center gap-4 p-4 bg-white rounded-lg shadow hover:shadow-md transition-shadow">
                    <form action="{{ route('todos.update', $todo) }}" method="POST">
                        @csrf
                        @method('PUT')
                        <input type="checkbox" name="completed" onchange="this.form.submit()"
                            {{ $todo->completed ? 'checked' : '' }}
                            class="w-5 h-5 text-blue-500">
                    </form>
                    
                    <span class="todo-title flex-1 {{ $todo->completed ? 'line-through text-gray-500' : '' }}">
                        {{ $todo->title }}
                    </span>
                    
                    <form action="{{ route('todos.destroy', $todo) }}" method="POST">
                        @csrf
                        @method('DELETE')
                        <button type="submit" 
                            class="delete-button px-3 py-1 text-red-500 hover:bg-red-100 rounded transition-colors">
                            Delete
                        </button>
                    </form>
                </div>
            @empty
                <p class="text-gray-500 text-center py-8">No todos yet. Add one above or use voice command!</p>
            @endforelse
        </div>
        </div>
    </div>

    <!-- Include Voice Recognition Script -->
    <script src="{{ asset('js/voice-recognition.js') }}"></script>
</body>
</html>
