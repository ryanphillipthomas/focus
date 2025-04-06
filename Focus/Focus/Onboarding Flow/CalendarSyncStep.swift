//
//  CalendarSyncStep.swift
//  Focus
//
//  Created by Ryan Thomas on 4/5/25.
//
import SwiftUI
// Calendar Sync Step
struct CalendarSyncStep: View {
    @EnvironmentObject var viewModel: OnboardingViewModel

    var body: some View {
        VStack(spacing: 20) {
            Text("Let’s sync your calendar").font(.title2)
            Text("Focus works best when it knows your availability").multilineTextAlignment(.center)

            Button("Connect Google Calendar") {
                // Add connection logic
                viewModel.next()
            }
            .buttonStyle(.borderedProminent)

            Button("Connect Apple Calendar") {
                // Add connection logic
                viewModel.next()
            }
            .buttonStyle(.bordered)

            Button("Skip for now") {
                viewModel.next()
            }
            .foregroundColor(.secondary)

            Spacer()
        }
        .padding()
    }
}
