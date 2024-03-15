import Foundation


enum TodoSort: String, CaseIterable {
    case `default` = "Default"
    case date = "Date"
    case priority = "Priority"
}


protocol TodoSorted {
    func sort(todos: [Todo]) -> [Todo]
}

class TodoSortDefault: TodoSorted {
    func sort(todos: [Todo]) -> [Todo] {
        return todos.sorted { (lhs, rhs) in
            if lhs.isDone != rhs.isDone {
                return !lhs.isDone
            } else if lhs.priority != rhs.priority {
                return lhs.priority.value > rhs.priority.value
            } else if lhs.complete != rhs.complete {
                return lhs.complete < rhs.complete
            } else {
                return lhs.text < rhs.text
            }
        }
    }
}

class TodoSortDate: TodoSorted {
    func sort(todos: [Todo]) -> [Todo] {
        return todos.sorted(by: { $0.complete < $1.complete })
    }
}

class TodoSortPriority: TodoSorted {
    func sort(todos: [Todo]) -> [Todo] {
        return todos.sorted(by: { $0.priority.value > $1.priority.value })
    }
}
