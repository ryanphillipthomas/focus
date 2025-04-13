//
//  OnboardingViewModel.swift
//  Focus
//
//  Created by Ryan Thomas on 4/5/25.
//
import SwiftUI
class OnboardingModel: ObservableObject {
    @Published var currentStep: Int = 0
    @Published var numberOfSteps: Int = 3

    // Data to persist throughout onboarding
    @Published var productivityStyle: [String] = []

    func next() {
        AnalyticsManager.shared.logEvent("onboarding_selection_next")
        if currentStep < numberOfSteps { currentStep += 1 }
    }

    func back() {
        AnalyticsManager.shared.logEvent("onboarding_selection_back")
        if currentStep > 0 { currentStep -= 1 }
    }
}
