import SwiftUI

@main
struct Cringly_flashcardsApp: App {
    @StateObject private var flashcardManager = FlashcardManager()
    @StateObject private var authManager = AuthManager()

    init() {
        NotificationManager.shared.requestPermission()
        NotificationManager.shared.scheduleDailyReminder()
    }

    var body: some Scene {
        WindowGroup {
            if authManager.isAuthenticated {
                HomeView()
                    .environmentObject(flashcardManager)
                    .environmentObject(authManager)
            } else {
                ContentView()
                    .environmentObject(flashcardManager)
                    .environmentObject(authManager)
            }
        }
    }
}
