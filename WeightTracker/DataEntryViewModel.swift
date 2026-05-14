import Foundation
import HealthKit

final class DataEntryViewModel: ObservableObject {
    @Published var weight: String = ""
    @Published var unit: HKUnit = .pound()

    private let healthKitService: HealthKitService

    init(healthKitService: HealthKitService, initialUnit: HKUnit = .pound()) {
        self.healthKitService = healthKitService
        self.unit = initialUnit
    }

    func logWeight() {
        guard let value = Double(weight) else {
            print("Cannot log weight: weight input is not a Double")
            return
        }
        healthKitService.saveWeight(value: value, unit: unit)
    }
}
