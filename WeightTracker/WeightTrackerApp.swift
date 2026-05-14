import SwiftUI

@main
struct WeightTrackerApp: App {
    @StateObject private var healthKitService = HealthKitService()
    let notificationService = NotificationService()

    init() {
        notificationService.requestPermission()
    }

    var body: some Scene {
        WindowGroup {
            MainView(notificationService: notificationService)
                .environmentObject(healthKitService)
        }
    }
}
