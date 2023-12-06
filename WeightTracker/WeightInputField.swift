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
    @State var weight: String
    @State var unit: HKUnit
    
    var body: some View {
        VStack {
            HStack {
                TextField("Weight", text: $weight)
                    .keyboardType(.decimalPad)
                    .font(.system(size: 30))
                Spacer()
                Picker("Units", selection: $unit) {
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
    
    private let steelGray = Color(white: 0.9)
    var border: some View {
        RoundedRectangle(cornerRadius: 15)
            .fill(steelGray)
    }
}

#Preview {
    WeightInputField(weight: "", unit: .pound())
}
