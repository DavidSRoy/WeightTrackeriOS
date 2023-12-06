//
//  WeightTrackerApp.swift
//  WeightTracker
//
//  Created by David Roy on 12/6/23.
//

import SwiftUI
import HealthKit

@main
struct WeightTrackerApp: App {
    static let healthStore: HKHealthStore? = HKHealthStore.isHealthDataAvailable() ? HKHealthStore() : nil
    
    private static let allTypes = Set([bodyMassType])
    private static let bodyMassType = HKObjectType.quantityType(forIdentifier: .bodyMass)!
    
    init() {
        WeightTrackerApp.requestPermissionsIfNotEnabled()
    }
    
    var body: some Scene {
        WindowGroup {
            MainView()
        }
    }
    
    private static func requestPermissionsIfNotEnabled() {
        guard let healthStore else {
            print("Health Data not available")
            return
        }

        let bodyMassAuth = healthStore.authorizationStatus(for: bodyMassType)
        
        if bodyMassAuth != .sharingAuthorized {
            healthStore.requestAuthorization(toShare: allTypes, read: allTypes) { (success, error) in
                if !success {
                    // Handle the error here.
                    print("Error requesting authorization: \(String(describing: error))")
                }
            }
        }
    }
}
