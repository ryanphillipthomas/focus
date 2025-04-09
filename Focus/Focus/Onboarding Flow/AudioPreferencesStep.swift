//
//  AudioPreferencesStep.swift
//  Focus
//
//  Created by Ryan Thomas on 4/5/25.
//
import SwiftUI
// Audio Preferences Step
struct AudioPreferencesStep: View {
    @EnvironmentObject var viewModel: OnboardingViewModel

    var body: some View {
        VStack(spacing: 20) {
            Text("Want tunes while you work?").font(.title2)
            Text("We’ll match focus tracks or podcasts to your task and mood")
                .multilineTextAlignment(.center)

            Button("Connect Spotify") {
                AnalyticsManager.shared.logEvent("onboarding_selection_spotify")
                viewModel.musicService = "Spotify"
                viewModel.next()
            }
            .buttonStyle(.bordered)

            Button("Connect Apple Music") {
                AnalyticsManager.shared.logEvent("onboarding_selection_apple_music")
                viewModel.musicService = "Apple Music"
                viewModel.next()
            }
            .buttonStyle(.bordered)

            Button("No thanks") {
                AnalyticsManager.shared.logEvent("onboarding_selection_no_thanks")
                viewModel.musicService = nil
                viewModel.next()
            }
            .foregroundColor(.secondary)

            Spacer()
        }
        .padding()
    }
}
