import SwiftUI

@main
struct WeightTrackerApp: App {
    @StateObject private var healthKitService = HealthKitService()

    var body: some Scene {
        WindowGroup {
            MainView()
                .environmentObject(healthKitService)
        }
    }
}
