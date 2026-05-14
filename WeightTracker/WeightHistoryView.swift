import SwiftUI
import HealthKit

struct WeightHistoryView: View {
    @EnvironmentObject private var healthKitService: HealthKitService
    @Environment(\.dismiss) private var dismiss
    let displayUnit: HKUnit
    let notificationService: NotificationService

    @AppStorage("reminderTimeInterval") private var reminderTimeInterval: Double = 8 * 3600
    @State private var reminderTime: Date = Date()

    private var unitLabel: String { displayUnit == .pound() ? "lb" : "kg" }

    private static let dateFormatter: DateFormatter = {
        let f = DateFormatter()
        f.dateStyle = .medium
        f.timeStyle = .short
        return f
    }()

    var body: some View {
        NavigationView {
            List {
                Section("Daily Reminder") {
                    DatePicker(
                        "Remind me at",
                        selection: $reminderTime,
                        displayedComponents: .hourAndMinute
                    )
                }

                Section("Entries") {
                    if healthKitService.entries.isEmpty {
                        Text("No entries yet")
                            .foregroundStyle(.secondary)
                    } else {
                        ForEach(healthKitService.entries) { entry in
                            HStack {
                                Text(Self.dateFormatter.string(from: entry.date))
                                Spacer()
                                Text(String(format: "%.1f \(unitLabel)", entry.value(in: displayUnit)))
                                    .fontWeight(.semibold)
                            }
                        }
                        .onDelete { indexSet in
                            indexSet.forEach { healthKitService.delete(healthKitService.entries[$0]) }
                        }
                    }
                }
            }
            .navigationTitle("Log")
            .navigationBarItems(trailing: Button("Done") { dismiss() })
            .onAppear {
                reminderTime = Date(timeIntervalSinceReferenceDate: reminderTimeInterval)
            }
            .onChange(of: reminderTime) { _, newTime in
                reminderTimeInterval = newTime.timeIntervalSinceReferenceDate
                notificationService.scheduleDaily(at: newTime)
            }
        }
    }
}

#Preview {
    WeightHistoryView(displayUnit: .pound(), notificationService: NotificationService())
        .environmentObject(HealthKitService())
}
