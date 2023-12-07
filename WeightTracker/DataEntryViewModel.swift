//
//  DataEntryViewModel.swift
//  WeightTracker
//
//  Created by David Roy on 12/6/23.
//

import Foundation
import HealthKit

final class DataEntryViewModel: ObservableObject {
    
    var weight: String
    var unit: HKUnit
    
    private let healthStore: HKHealthStore?
    
    private let bodyMassType: HKQuantityType!
    
    init(healthStore: HKHealthStore? = WeightTrackerApp.healthStore) {
        self.healthStore = healthStore
        bodyMassType = .quantityType(forIdentifier: .bodyMass)
        weight = ""
        unit = .pound()
    }
    
    func logWeight() {
        guard let weight = Double(weight) else {
            print("Cannot log weight: weight input is not a Double")
            return
        }
        guard let healthStore else {
            print("Health Data not available")
            return
        }

        let quantity = HKQuantity(unit: unit, doubleValue: weight)
        let sample = HKQuantitySample(type: bodyMassType, quantity: quantity, start: .now, end: .now)
        
        healthStore.save(sample) { (success, error) in
            if success {
                print("Weight sample successfully saved")
            }
            
            if let error {
                print("Error on saving weight sample: \(error)")
            }
        }
    }
}
