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
            print("🚫 Health data not available")
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
            print("❌ Health authorization failed: \(error)")
            isAuthorized = false
        }
    }

    func fetchHealthData() async {
        await fetchStepsToday()
        await fetchSleepLastNight()
    }

    private func fetchStepsToday() async {
        guard let stepsType = HKQuantityType.quantityType(forIdentifier: .stepCount) else { return }

        let startOfDay = Calendar.current.startOfDay(for: Date())
        let predicate = HKQuery.predicateForSamples(withStart: startOfDay, end: Date(), options: .strictStartDate)

        let query = HKStatisticsQuery(quantityType: stepsType, quantitySamplePredicate: predicate, options: .cumulativeSum) { _, result, _ in
            DispatchQueue.main.async {
                if let sum = result?.sumQuantity() {
                    self.stepCountToday = sum.doubleValue(for: .count())
                }
            }
        }

        healthStore.execute(query)
    }

    private func fetchSleepLastNight() async {
        guard let sleepType = HKCategoryType.categoryType(forIdentifier: .sleepAnalysis) else { return }

        let start = Calendar.current.date(byAdding: .day, value: -1, to: Calendar.current.startOfDay(for: Date()))!
        let end = Date()

        let predicate = HKQuery.predicateForSamples(withStart: start, end: end)

        let query = HKSampleQuery(sampleType: sleepType, predicate: predicate, limit: HKObjectQueryNoLimit, sortDescriptors: nil) { _, samples, _ in
            var totalSleep = 0.0

            for sample in samples as? [HKCategorySample] ?? [] {
                if sample.value == HKCategoryValueSleepAnalysis.asleep.rawValue {
                    totalSleep += sample.endDate.timeIntervalSince(sample.startDate)
                }
            }

            DispatchQueue.main.async {
                self.sleepHoursLastNight = totalSleep / 3600
            }
        }

        healthStore.execute(query)
    }
}
