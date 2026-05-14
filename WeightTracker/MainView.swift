import SwiftUI

struct MainView: View {
    @EnvironmentObject private var healthKitService: HealthKitService
    @State private var showDataEntrySheet = false

    var body: some View {
        DataEntryView(healthKitService: healthKitService)
    }
}

#Preview {
    MainView()
        .environmentObject(HealthKitService())
}
