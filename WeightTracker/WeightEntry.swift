import Foundation
import HealthKit

struct WeightEntry: Identifiable {
    let id: UUID
    let date: Date
    let quantity: HKQuantity
    let sample: HKQuantitySample

    func value(in unit: HKUnit) -> Double {
        quantity.doubleValue(for: unit)
    }
}
