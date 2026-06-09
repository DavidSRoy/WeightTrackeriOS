# WeightTracker

A minimal iOS app for logging body weight. Entries are stored directly in Apple Health, visualized as a 30-day trend chart, and backed by a configurable daily reminder notification.

## Features

- Log weight in pounds or kilograms
- 30-day trend chart on the home screen
- Logs sheet to browse and delete individual entries
- Daily reminder notification with a user-configured time

## HealthKit Integration

All weight data lives in Apple Health — the app has no local database. The integration is handled by `HealthKitService`, an `ObservableObject` that wraps `HKHealthStore` and exposes a `@Published var entries: [WeightEntry]` array that the chart and logs list observe directly.

### Authorization

The app requests read/write access to the `HKQuantityTypeIdentifier.bodyMass` quantity type on first launch via `HKHealthStore.requestAuthorization(toShare:read:)`. The entitlement key `com.apple.developer.healthkit` is required in the app's `.entitlements` file, and the Info.plist must include usage description strings for both reading and writing Health data:

```
NSHealthShareUsageDescription
NSHealthUpdateUsageDescription
```

### Writing a sample

Each logged weight is saved as an `HKQuantitySample` with a body mass quantity type, the user-selected unit (`HKUnit.pound()` or `HKUnit.gramUnit(with: .kilo)`), and the current timestamp as both the start and end date:

```swift
let quantity = HKQuantity(unit: unit, doubleValue: value)
let sample = HKQuantitySample(type: bodyMassType, quantity: quantity, start: .now, end: .now)
healthStore.save(sample) { success, error in ... }
```

### Reading samples

Entries are fetched with `HKSampleQuery`, sorted newest-first, and mapped to a lightweight `WeightEntry` model that holds the original `HKQuantitySample` reference (needed for deletion) alongside the `HKQuantity` for unit-flexible display:

```swift
let query = HKSampleQuery(
    sampleType: bodyMassType,
    predicate: nil,
    limit: HKObjectQueryNoLimit,
    sortDescriptors: [NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)]
) { _, samples, _ in
    let entries = (samples as? [HKQuantitySample] ?? []).map {
        WeightEntry(id: $0.uuid, date: $0.startDate, quantity: $0.quantity, sample: $0)
    }
    DispatchQueue.main.async { self?.entries = entries }
}
healthStore.execute(query)
```

### Deleting a sample

Because `WeightEntry` retains the original `HKQuantitySample`, deletion is a direct call to `HKHealthStore.delete(_:completionHandler:)` followed by a re-fetch to keep the published list in sync:

```swift
healthStore.delete(entry.sample) { [weak self] success, _ in
    if success { self?.fetchEntries() }
}
```

### Data flow

```
HealthKitService (@Published entries)
    ↑ save / delete / fetch
DataEntryViewModel          WeightHistoryView
    (log weight)               (delete entry)

    ↓ entries
WeightChartView   WeightHistoryView (list)
```

## Requirements

- iOS 17+
- Xcode 15+
- A device or simulator with HealthKit enabled
