import SwiftData
import SwiftUI
import Combine

final class TodoRepository {
    private let container: ModelContainer
    private let context: ModelContext
    
    @MainActor private init() {
        do {
            self.container = try ModelContainer(for: Todo.self)
            self.context = container.mainContext
        } catch {
            fatalError(error.localizedDescription)
        }
    }
    
    @MainActor static let shared = TodoRepository()
    
    func getAll() -> [Todo] {
        return safeWrapper {
            return try self
                .context
                .fetch(FetchDescriptor<Todo>())
        }
    }
    
    func getAll(query: String) -> [Todo] {
        let todoPredicate = #Predicate<Todo> { item in
            return item.text.localizedStandardContains(query)
        }
        let descriptor = FetchDescriptor<Todo>(predicate: todoPredicate)
        
        return safeWrapper {
            return try self
                .context
                .fetch(descriptor)
        }
    }
    
    func delete(_ todo: Todo) {
        safeWrapper {
            self.context.delete(todo)
        }
    }
    
    func update(_ todo: Todo) {
        safeWrapper {
            self.context.insert(todo)
            try context.save()
        }
    }
    
    private func safeWrapper<Element>(action: () throws -> Element) -> Element {
        do {
            return try action()
        } catch {
            fatalError(error.localizedDescription)
        }
    }
}
