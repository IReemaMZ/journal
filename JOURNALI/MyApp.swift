
import SwiftUI
import SwiftData

@main
struct MyApp: App {

    let modelContainer: ModelContainer

    @StateObject private var viewModel: JournalViewModel

    // MARK: - Initializer

    init() {
        do {
            let container = try ModelContainer(
                for: Journal.self
            )

            self.modelContainer = container

            _viewModel = StateObject(
                wrappedValue: JournalViewModel(
                    modelContext: container.mainContext
                )
            )

        } catch {
            fatalError(
                "Failed to initialize SwiftData: \(error)"
            )
        }
    }

    // MARK: - App Scene

    var body: some Scene {
        WindowGroup {
            ContentView(viewModel: viewModel)
        }
        .modelContainer(modelContainer)
    }
}
