//
//  CompletionStep.swift
//  Focus
//
//  Created by Ryan Thomas on 4/5/25.
//
import SwiftUI
// Completion Step
struct CompletionStep: View {
    let onDone: () -> Void

    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            Text("You're all set!").font(.largeTitle.bold())
            Text("Let’s plan your first focus block")
            Spacer()
            Button("Start Planning") {
                // Navigate to main app
                AnalyticsManager.shared.logEvent("onboarding_selection_start_planning")
                onDone()
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
    }
}
