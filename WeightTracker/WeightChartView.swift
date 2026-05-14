import SwiftUI
import Charts
import HealthKit

struct WeightChartView: View {
    let entries: [WeightEntry]
    let unit: HKUnit

    private var displayUnit: String { unit == .pound() ? "lb" : "kg" }

    private var last30Days: [WeightEntry] {
        let cutoff = Calendar.current.date(byAdding: .day, value: -30, to: .now) ?? .now
        return entries.filter { $0.date >= cutoff }.reversed()
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("Last 30 Days")
                .font(.headline)
                .padding(.horizontal)

            if last30Days.isEmpty {
                Text("No data yet")
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity, minHeight: 180)
            } else {
                Chart(last30Days) { entry in
                    LineMark(
                        x: .value("Date", entry.date),
                        y: .value("Weight", entry.value(in: unit))
                    )
                    .foregroundStyle(.blue)

                    PointMark(
                        x: .value("Date", entry.date),
                        y: .value("Weight", entry.value(in: unit))
                    )
                    .foregroundStyle(.blue)
                }
                .chartYAxisLabel(displayUnit)
                .frame(height: 180)
                .padding(.horizontal)
            }
        }
    }
}

#Preview {
    WeightChartView(entries: [], unit: .pound())
}
