import SwiftUI

struct TodoScreen: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var viewModel: TodoViewModel

    @Binding var todo: Todo
    
    var body: some View {
        Form {
            VStack(spacing: 8.0) {
                Text("Action on Todo")
                    .font(.title2)
                
                TextField(todo.text, text: $todo.text, prompt: Text("Todo Text"))
                    .textFieldStyle(.roundedBorder)
                    .padding(.top, 16)
                
                Toggle(isOn: $todo.isDone) {
                    Text("Is Completed?")
                }
                
                Picker("Choose Priority", selection: $todo.priority) {
                    ForEach(TodoPriority.allCases, id: \.self) { priority in
                        Text(priority.rawValue)
                    }
                }
                
                DatePicker("Completed Date", selection: $todo.complete)
                
                HStack {
                    Button("Back") { dismiss() }
                    Spacer()
                    Button("Save") {
                        viewModel.updateTodoAction.send(todo)
                        dismiss()
                    }
                    .disabled(todo.text.isEmpty)
                }
                .buttonStyle(.bordered)
            }
            .padding(.vertical, 8)
        }
    }
}
