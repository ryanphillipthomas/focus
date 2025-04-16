//
//  OnboardingListView.swift
//  Focus
//
//  Created by Ryan Thomas on 4/14/25.
//

import SwiftUI

struct OnboardingListView: View {
    @Binding var hasCompletedOnboarding: Bool

    var body: some View {
        List {
            Section(header: Text("Onboarding")) {
                NavigationLink("View Onboarding Flow") {
                    OnboardingFlow()
                }

                Button("Reset Onboarding") {
                    InAppLogStore.shared.append("Reset Onboarding Flow", for: "Onboarding", type: .onboarding)
                    AnalyticsManager.shared.logEvent("settings_selection_reset_onboarding")
                    hasCompletedOnboarding = false
                }
                .foregroundColor(.red)
            }
            NavigationLink("Logs") {
                InAppLogViewer(provider: "Onboarding")
            }
        }
    }
}
