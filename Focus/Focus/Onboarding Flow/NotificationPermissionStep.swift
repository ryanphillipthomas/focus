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
                requestNotificationPermission()
                viewModel.next()
            }
            .buttonStyle(.borderedProminent)

            Button("Skip") {
                viewModel.next()
            }
            .foregroundColor(.secondary)
            Spacer()
        }
        .padding()
    }

    func requestNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { granted, error in
            if let error = error {
                print("❌ Notification permission error: \(error)")
            } else {
                print("🔔 Notification permission granted: \(granted)")
                
                notificationsEnabled = granted
            }
        }
    }
}
