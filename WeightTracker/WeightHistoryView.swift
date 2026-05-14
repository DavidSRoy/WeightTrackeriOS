import SwiftUI
import HealthKit

struct WeightHistoryView: View {
    @EnvironmentObject private var healthKitService: HealthKitService
    @Environment(\.dismiss) private var dismiss
    let displayUnit: HKUnit

    private var unitLabel: String { displayUnit == .pound() ? "lb" : "kg" }

    private static let dateFormatter: DateFormatter = {
        let f = DateFormatter()
        f.dateStyle = .medium
        f.timeStyle = .short
        return f
    }()

    var body: some View {
        NavigationView {
            Group {
                if healthKitService.entries.isEmpty {
                    Text("No entries yet")
                        .foregroundStyle(.secondary)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    List {
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
        }
    }
}

#Preview {
    WeightHistoryView(displayUnit: .pound())
        .environmentObject(HealthKitService())
}
