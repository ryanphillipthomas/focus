//
//  WelcomeStep.swift
//  Focus
//
//  Created by Ryan Thomas on 4/5/25.
//
import SwiftUI
struct OnboardingWelcomeStep: View {
    @EnvironmentObject var viewModel: OnboardingModel

    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            Text("Welcome to Focus").font(.largeTitle.bold())
            Text("Your AI-powered productivity sidekick").multilineTextAlignment(.center)
            Spacer()
            Button("Get Started") {
                AnalyticsManager.shared.logEvent("onboarding_selection_get_started")
                viewModel.next()
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
        .analyticsScreen(self)
    }
}
