//
//  EnergyTrackingStep.swift
//  Focus
//
//  Created by Ryan Thomas on 4/5/25.
//
import SwiftUI
// Energy Tracking Step
struct EnergyTrackingStep: View {
    @EnvironmentObject var viewModel: OnboardingViewModel

    var body: some View {
        VStack(spacing: 20) {
            Text("Track your energy?").font(.title2)
            Text("We can optimize your schedule based on sleep and energy")
                .multilineTextAlignment(.center)

            Button("Connect Apple Health") {
                AnalyticsManager.shared.logEvent("onboarding_selection_apple_health")
                viewModel.energyTrackingEnabled = true
                viewModel.next()
            }
            .buttonStyle(.bordered)

            Button("Set Manually") {
                AnalyticsManager.shared.logEvent("onboarding_selection_health_manual")
                viewModel.energyTrackingEnabled = false
                viewModel.next()
            }
            .buttonStyle(.bordered)

            Button("Skip") {
                viewModel.next()
            }
            .foregroundColor(.secondary)

            Spacer()
        }
        .padding()
    }
}
