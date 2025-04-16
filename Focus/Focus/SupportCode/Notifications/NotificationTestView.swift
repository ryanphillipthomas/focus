//
//  NotificationTestView.swift
//  Focus
//
//  Created by Ryan Thomas on 4/7/25.
//

import SwiftUI
import UserNotifications


struct NotificationTestView: View {
    var body: some View {
        List {
            Section(header: Text("Setup Notifications")) {
                Button("Request Permission") {
                    FirebaseManager.shared.requestNotificationPermissions()
                }
            }

            Section(header: Text("Test Notifications")) {
                ForEach(UserNotificationPreferences.defaultPreferences.preferences, id: \.id) { type in
                    Button("Send: \(type.title)") {
                        scheduleTestNotification(type: type)
                    }
                }
            }
            
            Section(header: Text("Test All Notifications")) {
                Button("Test All Notifications") {
                    scheduleAllTestNotifications()
                }
            }
            Section(header: Text("Logs")) {
                NavigationLink("Logs") {
                    InAppLogViewer(provider: "Notifications")
                }
            }
            
        }.navigationTitle("Notifications")
    }
}

func scheduleAllTestNotifications() {
    for (i, type) in UserNotificationPreferences.defaultPreferences.preferences.enumerated() {
        let delay = Double(3 * (i + 1))
        scheduleTestNotification(type: type, in: delay)
        InAppLogStore.shared.append("Queued test notification '\(type.title)' in \(delay) seconds", for: "Notifications", type: .notifications)
    }
}

func scheduleTestNotification(type: NotificationType, in seconds: TimeInterval = 5) {
    let content = UNMutableNotificationContent()
    content.title = type.title
    content.body = type.description
    content.sound = .default

    let trigger = UNTimeIntervalNotificationTrigger(timeInterval: seconds, repeats: false)
    let request = UNNotificationRequest(identifier: type.id, content: content, trigger: trigger)

    UNUserNotificationCenter.current().add(request) { error in
        if let error = error {
            let message = "Failed to schedule test notification '\(type.title)': \(error.localizedDescription)"
            InAppLogStore.shared.append(message, for: "Notifications", type: .notifications)
        } else {
            let message = "Scheduled notification '\(type.title)' for delivery in \(Int(seconds))s"
            InAppLogStore.shared.append(message, for: "Notifications", type: .notifications)
        }
    }
}


