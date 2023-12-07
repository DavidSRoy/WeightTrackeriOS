//
//  DataEntryView.swift
//  WeightTracker
//
//  Created by David Roy on 12/6/23.
//

import SwiftUI
import HealthKit

struct DataEntryView: View {

    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel = DataEntryViewModel()

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
    DataEntryView()
}
