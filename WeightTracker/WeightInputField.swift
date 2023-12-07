//
//  WeightInputField.swift
//  WeightTracker
//
//  Created by David Roy on 12/6/23.
//

import Foundation

import SwiftUI
import HealthKit

struct WeightInputField: View {
    enum FocusField: Hashable {
        case weightField
    }

    @ObservedObject var viewModel: DataEntryViewModel
    @FocusState private var focusedField: FocusField?

    var body: some View {
        VStack {
            HStack {
                TextField("Weight", text: $viewModel.weight)
                    .keyboardType(.decimalPad)
                    .font(.system(size: 30))
                    .focused($focusedField, equals: .weightField)
                    .onAppear {
                        self.focusedField = .weightField
                    }

                Spacer()
                Picker("Units", selection: $viewModel.unit) {
                    Text("Pounds (lb)").tag(HKUnit.pound())
                    Text("Kilograms (kg)").tag(HKUnit.gramUnit(with: .kilo))
                }
                .font(.title)
            }
            .padding(.all, 20)
        }
        .background(border)
        .padding(.all)
    }
    
    private let gray = Color(white: 0.9)
    var border: some View {
        RoundedRectangle(cornerRadius: 15)
            .fill(gray)
    }
}

#Preview {
    WeightInputField(viewModel: DataEntryViewModel())
}
