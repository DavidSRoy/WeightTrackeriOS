//
//  DataEntryView.swift
//  WeightTracker
//
//  Created by David Roy on 12/6/23.
//

import SwiftUI
import HealthKit

struct DataEntryView: View {
    @StateObject private var viewModel = DataEntryViewModel()
    
    @State private var weight = ""
    @State private var unit: HKUnit = .pound()
    
    var body: some View {
        VStack {
            TextField("Weight", text: $weight)
                .keyboardType(.decimalPad)
            Picker("Units", selection: $unit) {
                Text("Pounds (lb)").tag(HKUnit.pound())
                Text("Kilograms (kg)").tag(HKUnit.gramUnit(with: .kilo))
            }
            Button {
                if let weight = Double(weight) {
                    viewModel.logWeight(weight, unit: unit)
                } else {
                    // error
                }
            } label: {
                Text("Log Weight")
            }
        }
        .padding()
    }
}

#Preview {
    DataEntryView()
}
