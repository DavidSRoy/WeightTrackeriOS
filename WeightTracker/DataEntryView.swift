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
    
    @State private var weight = ""
    @State private var unit: HKUnit = .pound()
    
    var body: some View {
        NavigationView {
            VStack {
                WeightInputField(weight: weight, unit: unit)
                
                Button {
                    if let weight = Double(weight) {
                        viewModel.logWeight(weight, unit: unit)
                    } else {
                        // error
                        print("Invalid Weight Entry; weight is not a double: received value: \(weight)")
                    }
                } label: {
                    Text("Log Weight")
                }
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
