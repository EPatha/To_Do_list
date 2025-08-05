import Foundation

struct Task {
    var title: String
    var description: String
    var isCompleted: Bool
    
    init(title: String, description: String) {
        self.title = title
        self.description = description
        self.isCompleted = false
    }
    
    mutating func markAsCompleted() {
        isCompleted = true
    }
    
    mutating func updateDescription(newDescription: String) {
        description = newDescription
    }
}