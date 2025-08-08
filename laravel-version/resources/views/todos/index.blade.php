<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Todo List</title>
    <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-gray-100">
    <div class="container mx-auto px-4 py-8">
        <h1 class="text-3xl font-bold mb-8">Todo List</h1>
        
        <!-- Add Todo Form -->
        <form action="{{ route('todos.store') }}" method="POST" class="mb-8">
            @csrf
            <div class="flex gap-4">
                <input type="text" name="title" placeholder="Enter your todo" required
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
                <div class="flex items-center gap-4 p-4 bg-white rounded-lg shadow">
                    <form action="{{ route('todos.update', $todo) }}" method="POST">
                        @csrf
                        @method('PUT')
                        <input type="checkbox" name="completed" onchange="this.form.submit()"
                            {{ $todo->completed ? 'checked' : '' }}
                            class="w-5 h-5 text-blue-500">
                    </form>
                    
                    <span class="flex-1 {{ $todo->completed ? 'line-through text-gray-500' : '' }}">
                        {{ $todo->title }}
                    </span>
                    
                    <form action="{{ route('todos.destroy', $todo) }}" method="POST">
                        @csrf
                        @method('DELETE')
                        <button type="submit" 
                            class="px-3 py-1 text-red-500 hover:bg-red-100 rounded">
                            Delete
                        </button>
                    </form>
                </div>
            @empty
                <p class="text-gray-500 text-center">No todos yet. Add one above!</p>
            @endforelse
        </div>
    </div>
</body>
</html>
