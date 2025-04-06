//
//  OnboardingViewModel.swift
//  Focus
//
//  Created by Ryan Thomas on 4/5/25.
//
import SwiftUI
class OnboardingViewModel: ObservableObject {
    @Published var currentStep: Int = 0
    @Published var numberOfSteps: Int = 8

    // Data to persist throughout onboarding
    @Published var productivityStyle: [String] = []
    @Published var workHours: [String: (Date, Date)] = [:]
    @Published var energyTrackingEnabled: Bool = false
    @Published var musicService: String? = nil
    @Published var selectedAnimal: String = "Fox"

    func next() {
        if currentStep < numberOfSteps { currentStep += 1 }
    }

    func back() {
        if currentStep > 0 { currentStep -= 1 }
    }
}
