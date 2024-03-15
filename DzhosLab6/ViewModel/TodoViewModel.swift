import Combine

import SwiftData
import SwiftUI

class TodoViewModel: ObservableObject {
    @Published var todos: [Todo] = []
    @Published var isLoading: Bool = true
    
    @Published var searchText: String = ""
    @Published var sortType: TodoSort = .default
    
    let updateTodoAction = PassthroughSubject<Todo, Never>()
    let deleteTodoAction = PassthroughSubject<IndexSet, Never>()
    let refreshAction = PassthroughSubject<Void, Never>()
    
    private var bag = Set<AnyCancellable>()
    private let repository: TodoRepository = .shared
    
    init() {
        defer { isLoading = false }
        todos = repository.getAll()
        
        updateTodoAction
            .sink { [weak self] todo in self?.updateTodo(todo) }
            .store(in: &bag)
        
        deleteTodoAction
            .sink { [weak self] indexSet in self?.deleteTodos(indexSet) }
            .store(in: &bag)
        
        Publishers.CombineLatest3($searchText, $sortType, refreshAction)
            .sink(receiveValue: { [weak self] (text, sort, _) in  self?.searchTodo(text, sort) })
            .store(in: &self.bag)
    }
    
    private func searchTodo(_ text: String, _ sort: TodoSort) {
        isLoading = true
        defer { isLoading = false }

        print("Search Todo \(text) \(sort)")

        let rawTodos: [Todo] = if text.isEmpty {
            repository.getAll()
        } else {
            repository.getAll(query: text)
        }
        
        let todoSorted: TodoSorted = switch sort {
            case .date: TodoSortDate()
            case .default: TodoSortDefault()
            case .priority: TodoSortPriority()
        }
        
        let sortedTodo = todoSorted.sort(todos: rawTodos)
        print("Sorted Todo \(sortedTodo)")
         
        todos = sortedTodo
    }
    
    private func deleteTodos(_ indexs: IndexSet) {
        isLoading = true
        defer { isLoading = false }
        
        for index in indexs {
            let todo = todos[index]
            repository.delete(todo)
        }
        
        refreshAction.send(())
    }
    
    private func updateTodo(_ todo: Todo) {
        isLoading = true
        defer { isLoading = false }
        
        repository.update(todo)
        refreshAction.send(())
    }
}
