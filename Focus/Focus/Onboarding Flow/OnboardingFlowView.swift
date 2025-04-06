//
//  OnboardingFlowView.swift
//  Focus
//
//  Created by Ryan Thomas on 4/5/25.
//
import SwiftUI
struct OnboardingFlowView: View {
    @StateObject var viewModel = OnboardingViewModel()
    @AppStorage("hasCompletedOnboarding") var hasCompletedOnboarding = false

    var body: some View {
#if os(iOS)
        TabView(selection: $viewModel.currentStep) {
            WelcomeStep().tag(0)
            ProductivityStyleStep().tag(1)
            CalendarSyncStep().tag(2)
            WorkHoursStep().tag(3)
            EnergyTrackingStep().tag(4)
            AudioPreferencesStep().tag(5)
            AnimalCompanionStep().tag(6)
            NotificationPermissionStep().tag(7)
            CompletionStep(onDone: {
                hasCompletedOnboarding = true
            }).tag(8)
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
                case 2: CalendarSyncStep()
                case 3: WorkHoursStep()
                case 4: EnergyTrackingStep()
                case 5: AudioPreferencesStep()
                case 6: AnimalCompanionStep()
                case 7: NotificationPermissionStep().tag(7)
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
