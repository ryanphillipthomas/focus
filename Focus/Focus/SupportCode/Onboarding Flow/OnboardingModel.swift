//
//  OnboardingViewModel.swift
//  Focus
//
//  Created by Ryan Thomas on 4/5/25.
//
import SwiftUI

class OnboardingModel: ObservableObject {
    @Published var currentStep: Int = 0
    @Published var numberOfSteps: Int = 2

    // Data to persist throughout onboarding
    @Published var productivityStyle: [String] = []

    func next() {
        AnalyticsManager.shared.logEvent("onboarding_selection_next")
        if currentStep < numberOfSteps {
            currentStep += 1
            InAppLogStore.shared.append("Advanced to onboarding step \(currentStep)", for: "Onboarding", type: .onboarding)
        } else {
            InAppLogStore.shared.append("Attempted to go beyond final onboarding step", for: "Onboarding", type: .onboarding)
        }
    }

    func back() {
        AnalyticsManager.shared.logEvent("onboarding_selection_back")
        if currentStep > 0 {
            currentStep -= 1
            InAppLogStore.shared.append("Went back to onboarding step \(currentStep)", for: "Onboarding", type: .onboarding)
        } else {
            InAppLogStore.shared.append("Attempted to go back from step 0", for: "Onboarding", type: .onboarding)
        }
    }
}
