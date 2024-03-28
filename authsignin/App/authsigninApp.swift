
import SwiftUI
import Firebase
@main
struct authsigninApp: App {
    @StateObject var viewModel = AuthViewModel()

    init() {
        FirebaseApp.configure()
    }
    var body: some Scene {
        WindowGroup {
         ContentView()
                .environmentObject(viewModel)
        }
    }
}
