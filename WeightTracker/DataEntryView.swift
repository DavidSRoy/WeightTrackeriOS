import SwiftUI

struct DataEntryView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel: DataEntryViewModel

    init(healthKitService: HealthKitService) {
        _viewModel = StateObject(wrappedValue: DataEntryViewModel(healthKitService: healthKitService))
    }

    var body: some View {
        NavigationView {
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
            .navigationBarTitle("Enter Weight")
            .navigationBarItems(trailing:
                Button("Done") {
                    dismiss()
                })
            .padding()
        }
    }
}

#Preview {
    DataEntryView(healthKitService: HealthKitService())
}
