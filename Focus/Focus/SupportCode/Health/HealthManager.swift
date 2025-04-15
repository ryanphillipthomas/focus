//
//  HealthManager.swift
//  Focus
//
//  Created by Ryan Thomas on 4/6/25.
//


import HealthKit
import Foundation

@MainActor
class HealthManager: ObservableObject {
    private let healthStore = HKHealthStore()

    @Published var stepCountToday: Double = 0
    @Published var sleepHoursLastNight: Double = 0
    @Published var isAuthorized: Bool = false

    func requestAuthorization() async {
        guard HKHealthStore.isHealthDataAvailable() else {
            InAppLogStore.shared.append("Health data not available", for: "Apple Health", type: .health)
            return
        }

        let readTypes: Set = [
            HKObjectType.quantityType(forIdentifier: .stepCount)!,
            HKObjectType.categoryType(forIdentifier: .sleepAnalysis)!
        ]

        do {
            try await healthStore.requestAuthorization(toShare: [], read: readTypes)
            isAuthorized = true
            await fetchHealthData()
        } catch {
            InAppLogStore.shared.append("Health authorization failed: \(error)", for: "Apple Health", type: .health)
            isAuthorized = false
        }
    }

    func fetchHealthData() async {
        await fetchStepsToday()
        await fetchSleepLastNight()
    }

    private func fetchStepsToday() async {
        guard let stepsType = HKQuantityType.quantityType(forIdentifier: .stepCount) else {
            InAppLogStore.shared.append("Failed to get stepCount quantity type.", for: "Apple Health", type: .health)
            return
        }

        let startOfDay = Calendar.current.startOfDay(for: Date())
        let predicate = HKQuery.predicateForSamples(withStart: startOfDay, end: Date(), options: .strictStartDate)

        let query = HKStatisticsQuery(quantityType: stepsType, quantitySamplePredicate: predicate, options: .cumulativeSum) { _, result, error in
            DispatchQueue.main.async {
                if let error = error {
                    InAppLogStore.shared.append("HealthKit error fetching steps: \(error.localizedDescription)", for: "Apple Health", type: .health)
                    return
                }

                if let sum = result?.sumQuantity() {
                    self.stepCountToday = sum.doubleValue(for: .count())
                    InAppLogStore.shared.append("Fetched \(Int(self.stepCountToday)) steps for today.", for: "Apple Health", type: .health)
                } else {
                    InAppLogStore.shared.append("No steps data returned for today.", for: "Apple Health", type: .health)
                }
            }
        }

        healthStore.execute(query)
    }

    private func fetchSleepLastNight() async {
        guard let sleepType = HKCategoryType.categoryType(forIdentifier: .sleepAnalysis) else {
            InAppLogStore.shared.append("Failed to get sleepAnalysis category type.", for: "Apple Health", type: .health)
            return
        }

        let start = Calendar.current.date(byAdding: .day, value: -1, to: Calendar.current.startOfDay(for: Date()))!
        let end = Date()
        let predicate = HKQuery.predicateForSamples(withStart: start, end: end)

        let query = HKSampleQuery(sampleType: sleepType, predicate: predicate, limit: HKObjectQueryNoLimit, sortDescriptors: nil) { _, samples, error in
            if let error = error {
                InAppLogStore.shared.append("HealthKit error fetching sleep: \(error.localizedDescription)", for: "Apple Health", type: .health)
                return
            }

            var totalSleep = 0.0

            let sleepSamples = samples as? [HKCategorySample] ?? []
            if sleepSamples.isEmpty {
                InAppLogStore.shared.append("No sleep samples returned for last night.", for: "Apple Health", type: .health)
            }

            for sample in sleepSamples {
                if sample.value == HKCategoryValueSleepAnalysis.asleep.rawValue {
                    totalSleep += sample.endDate.timeIntervalSince(sample.startDate)
                }
            }

            DispatchQueue.main.async {
                self.sleepHoursLastNight = totalSleep / 3600
                if self.sleepHoursLastNight > 0 {
                    InAppLogStore.shared.append(
                        "Sleep Hours Last Night: \(String(format: "%.2f", self.sleepHoursLastNight))",
                        for: "Apple Health",
                        type: .health
                    )
                }
            }
        }

        healthStore.execute(query)
    }

}
