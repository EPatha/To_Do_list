import Foundation

class TaskController {
    private var tasks: [Task] = []

    // Create a new task
    func createTask(title: String, description: String) -> Task {
        let newTask = Task(title: title, description: description)
        tasks.append(newTask)
        return newTask
    }

    // Update an existing task
    func updateTask(task: Task, title: String?, description: String?, isCompleted: Bool?) {
        if let title = title {
            task.title = title
        }
        if let description = description {
            task.description = description
        }
        if let isCompleted = isCompleted {
            task.isCompleted = isCompleted
        }
    }

    // Delete a task
    func deleteTask(task: Task) {
        tasks.removeAll { $0.id == task.id }
    }

    // Get all tasks
    func getAllTasks() -> [Task] {
        return tasks
    }

    // Get completed tasks
    func getCompletedTasks() -> [Task] {
        return tasks.filter { $0.isCompleted }
    }

    // Get pending tasks
    func getPendingTasks() -> [Task] {
        return tasks.filter { !$0.isCompleted }
    }
}