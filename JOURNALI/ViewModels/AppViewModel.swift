
import Foundation
import Combine

@MainActor
final class AppViewModel: ObservableObject {

    // MARK: - Published Properties

    @Published private(set) var isShowingSplash = true

    // MARK: - Splash Screen

    func finishSplashAfterDelay() async {

        do {
            try await Task.sleep(for: .seconds(2))
        } catch {
            return
        }

        isShowingSplash = false
    }
}
