import SwiftUI
import HealthKit

struct DataEntryView: View {
    @Binding var displayUnit: HKUnit
    @StateObject private var viewModel: DataEntryViewModel

    init(healthKitService: HealthKitService, displayUnit: Binding<HKUnit>) {
        _displayUnit = displayUnit
        _viewModel = StateObject(wrappedValue: DataEntryViewModel(
            healthKitService: healthKitService,
            initialUnit: displayUnit.wrappedValue
        ))
    }

    var body: some View {
        VStack {
            WeightInputField(viewModel: viewModel)

            Button {
                viewModel.logWeight()
            } label: {
                Text("Log Weight")
            }
            .padding()
            .background(.blue)
            .foregroundColor(.white)
            .clipShape(.capsule)
        }
        .padding()
        .onChange(of: viewModel.unit) { _, newUnit in
            displayUnit = newUnit
        }
    }
}

#Preview {
    DataEntryView(
        healthKitService: HealthKitService(),
        displayUnit: .constant(.pound())
    )
}
