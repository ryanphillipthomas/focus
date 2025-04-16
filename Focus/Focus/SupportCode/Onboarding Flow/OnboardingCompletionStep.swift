//
//  CompletionStep.swift
//  Focus
//
//  Created by Ryan Thomas on 4/5/25.
//
import SwiftUI

// Completion Step
struct OnboardingCompletionStep: View {
    let onDone: () -> Void

    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            Text("You're all set!").font(.largeTitle.bold())
            Text("Let’s plan your first focus block")
            Spacer()
            Button("Start Planning") {
                AnalyticsManager.shared.logEvent("onboarding_selection_start_planning")
                InAppLogStore.shared.append("Completed onboarding and tapped 'Start Planning'", for: "Onboarding", type: .onboarding)
                onDone()
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
        .analyticsScreen(self)
    }
}
