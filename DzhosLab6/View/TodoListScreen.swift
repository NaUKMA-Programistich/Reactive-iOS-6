import SwiftUI

struct TodoListScreen: View {
    @EnvironmentObject var viewModel: TodoViewModel

    @State var editTodo: Todo = Todo.getEditTodo()
    @State var isEditTodoPresented: Bool = false
    
    var body: some View {
        if viewModel.isLoading {
            ProgressView()
        } else {
            NavigationView {
                List {
                    ForEach(viewModel.todos) { todo in
                        VStack(alignment: HorizontalAlignment.leading) {
                            Text("Text: \(todo.text)")
                            Text("Priority: \(todo.priority.rawValue)")
                            Text("Date: \(todo.getHumanDate())")
                            Text("Completed: \(todo.isDone)")
                        }
                        .onTapGesture { self.edit(todo: todo) }
                    }
                    .onDelete(perform: delete)
                }
                .toolbar {
                    ToolbarItemGroup(placement: .automatic) {
                        Menu("Sort by \(viewModel.sortType.rawValue)") {
                            ForEach(TodoSort.allCases, id: \.self) { sort in
                                Button("Sort by \(sort.rawValue)") {
                                    viewModel.sortType = sort
                                }
                            }
                        }
                        Button(action: add) {
                            Label("Add Todo", systemImage: "plus")
                        }
                    }
                }
                .refreshable {
                    viewModel.refreshAction.send(())
                }
                .searchable(text: $viewModel.searchText, prompt: "Search Todo")
            }
            .sheet(isPresented: $isEditTodoPresented) {
                TodoScreen(todo: $editTodo)
            }
            .onChange(of: viewModel.todos) { oldValue, newValue in
                print("State \(oldValue) \(newValue)")
            }
        }
    }
    
    private func add() {
        self.editTodo = Todo.getEditTodo()
        self.isEditTodoPresented = true
    }

    private func delete(offsets: IndexSet) {
        viewModel.deleteTodoAction.send(offsets)
    }
    
    private func edit(todo: Todo) {
        self.editTodo = todo
        self.isEditTodoPresented = true
    }
}
