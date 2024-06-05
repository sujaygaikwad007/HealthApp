import SwiftUI

@main
struct HealthAppApp: App {
    @StateObject var manager = HealthManager()
    var body: some Scene {
        WindowGroup {
            ActivityTabView()
                .environmentObject(manager)
        }
    }
}
