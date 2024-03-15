import SwiftUI
import SwiftData

@main
struct DzhosLab5App: App {
    @StateObject var viewModel = TodoViewModel()

    var body: some Scene {
        WindowGroup {
            TodoListScreen()
        }
        .environmentObject(viewModel)
    }
}
