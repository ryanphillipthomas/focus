//
//  WelcomeStep.swift
//  Focus
//
//  Created by Ryan Thomas on 4/5/25.
//
import SwiftUI
struct WelcomeStep: View {
    @EnvironmentObject var viewModel: OnboardingViewModel

    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            Text("Welcome to Focus").font(.largeTitle.bold())
            Text("Your AI-powered productivity sidekick").multilineTextAlignment(.center)
            Spacer()
            Button("Get Started") {
                viewModel.next()
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
    }
}
