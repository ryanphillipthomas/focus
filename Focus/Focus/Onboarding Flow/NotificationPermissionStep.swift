//
//  NotificationPermissionStep.swift
//  Focus
//
//  Created by Ryan Thomas on 4/5/25.
//
import SwiftUI
import UserNotifications

struct NotificationPermissionStep: View {
    @EnvironmentObject var viewModel: OnboardingViewModel
    @AppStorage("notificationsEnabled") var notificationsEnabled = false

    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            Text("Enable Notifications")
                .font(.title2)
            Text("We’ll remind you when your focus sessions are done — even if you leave the app.")
                .multilineTextAlignment(.center)
                .padding()

            Button("Allow Notifications") {
                AnalyticsManager.shared.logEvent("onboarding_selection_allow_notifications")
                FirebaseManager.shared.requestNotificationPermissions()
                viewModel.next()
            }
            .buttonStyle(.borderedProminent)

            Button("Skip") {
                AnalyticsManager.shared.logEvent("onboarding_selection_skip")
                viewModel.next()
            }
            .foregroundColor(.secondary)
            Spacer()
        }
        .padding()
    }
}
