import SwiftData
import Foundation

@Model
final class Todo: CustomStringConvertible {
    var description: String {
        return "Todo \(text) \(complete) \(priority) \(isDone)"
    }
    
    var text: String
    var timestamp: Date
    var complete: Date
    var priority: TodoPriority
    var isDone: Bool
    let id: UUID
    
    init(
        text: String,
        priority: TodoPriority,
        complete: Date,
        isDone: Bool
    ) {
        self.id = UUID()
        self.text = text
        self.timestamp = .now
        self.complete = complete
        self.priority = priority
        self.isDone = isDone
    }
    
    func getHumanDate() -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .medium
        
        return formatter.string(from: self.complete)
    }
    
    static func getEditTodo() -> Todo {
        return Todo(text: "", priority: .high, complete: .now, isDone: false)
    }
}

enum TodoPriority: String, Codable, CaseIterable {
    case high = "High", medium = "Medium", low = "Low"
    
    var value: Int {
        return switch self {
        case .high: 3
        case .medium: 2
        case .low: 1
        }
    }
}
