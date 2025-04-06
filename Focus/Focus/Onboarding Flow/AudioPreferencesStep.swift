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
                viewModel.musicService = "Spotify"
                viewModel.next()
            }
            .buttonStyle(.bordered)

            Button("Connect Apple Music") {
                viewModel.musicService = "Apple Music"
                viewModel.next()
            }
            .buttonStyle(.bordered)

            Button("No thanks") {
                viewModel.musicService = nil
                viewModel.next()
            }
            .foregroundColor(.secondary)

            Spacer()
        }
        .padding()
    }
}
