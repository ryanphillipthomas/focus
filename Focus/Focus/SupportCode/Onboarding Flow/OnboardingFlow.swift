//
//  OnboardingFlowView.swift
//  Focus
//
//  Created by Ryan Thomas on 4/5/25.
//
import SwiftUI
struct OnboardingFlow: View {
    @StateObject var viewModel = OnboardingModel()
    @AppStorage("hasCompletedOnboarding") var hasCompletedOnboarding = false

    var body: some View {
#if os(iOS)
        TabView(selection: $viewModel.currentStep) {
            OnboardingWelcomeStep().tag(0)
            OnboardingExampleStep().tag(1)
            OnboardingCompletionStep(onDone: {
                AnalyticsManager.shared.logEvent("onboarding_completed")
                hasCompletedOnboarding = true
            }).tag(2)
        }
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
        .animation(.easeInOut, value: viewModel.currentStep)
        .environmentObject(viewModel)
#else
        VStack {
            // Show current step manually for macOS
            Group {
                switch viewModel.currentStep {
                case 0: WelcomeStep()
                case 1: ProductivityStyleStep()
                case 8: CompletionStep(onDone:{
                 hasCompletedOnboarding = true
                })
                default: EmptyView()
                }
            }
            .animation(.easeInOut, value: viewModel.currentStep)
            .environmentObject(viewModel)
        }
#endif
    }
}
