import SwiftUI
import HealthKit

struct MainView: View {
    @EnvironmentObject private var healthKitService: HealthKitService
    let notificationService: NotificationService
    @State private var showLogs = false
    @State private var displayUnit: HKUnit = .pound()

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    WeightChartView(entries: healthKitService.entries, unit: displayUnit)

                    DataEntryView(healthKitService: healthKitService, displayUnit: $displayUnit)

                    Button("View Logs") {
                        showLogs = true
                    }
                    .padding(.bottom)
                }
            }
            .navigationTitle("Weight Tracker")
            .onAppear { healthKitService.fetchEntries() }
            .sheet(isPresented: $showLogs) {
                WeightHistoryView(displayUnit: displayUnit, notificationService: notificationService)
            }
        }
    }
}

#Preview {
    MainView(notificationService: NotificationService())
        .environmentObject(HealthKitService())
}
