import Foundation
import HealthKit
import Combine

final class HealthKitService: ObservableObject {
    @Published private(set) var entries: [WeightEntry] = []

    private let healthStore: HKHealthStore?
    private let bodyMassType = HKQuantityType.quantityType(forIdentifier: .bodyMass)!

    init() {
        healthStore = HKHealthStore.isHealthDataAvailable() ? HKHealthStore() : nil
        requestAuthorizationIfNeeded()
        fetchEntries()
    }

    private func requestAuthorizationIfNeeded() {
        guard let healthStore else { return }
        let types: Set<HKSampleType> = [bodyMassType]
        guard healthStore.authorizationStatus(for: bodyMassType) != .sharingAuthorized else { return }
        healthStore.requestAuthorization(toShare: types, read: types) { _, error in
            if let error { print("HealthKit auth error: \(error)") }
        }
    }

    func fetchEntries() {
        guard let healthStore else { return }
        let sort = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)
        let query = HKSampleQuery(
            sampleType: bodyMassType,
            predicate: nil,
            limit: HKObjectQueryNoLimit,
            sortDescriptors: [sort]
        ) { [weak self] _, samples, error in
            if let error { print("HealthKit fetch error: \(error)") }
            let entries = (samples as? [HKQuantitySample] ?? []).map {
                WeightEntry(id: $0.uuid, date: $0.startDate, quantity: $0.quantity, sample: $0)
            }
            DispatchQueue.main.async { self?.entries = entries }
        }
        healthStore.execute(query)
    }

    func saveWeight(value: Double, unit: HKUnit) {
        guard let healthStore else { return }
        let quantity = HKQuantity(unit: unit, doubleValue: value)
        let sample = HKQuantitySample(type: bodyMassType, quantity: quantity, start: .now, end: .now)
        healthStore.save(sample) { [weak self] success, error in
            if let error { print("HealthKit save error: \(error)") }
            if success { self?.fetchEntries() }
        }
    }

    func delete(_ entry: WeightEntry) {
        guard let healthStore else { return }
        healthStore.delete(entry.sample) { [weak self] success, error in
            if let error { print("HealthKit delete error: \(error)") }
            if success { self?.fetchEntries() }
        }
    }
}
