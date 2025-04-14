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
        }.navigationTitle("Notifications")
    }
}

func scheduleAllTestNotifications() {
    for (i, type) in UserNotificationPreferences.defaultPreferences.preferences.enumerated() {
        scheduleTestNotification(type: type, in: Double(3 * (i + 1)))
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
            print("Failed to schedule test notification: \(error)")
        } else {
            print("Scheduled notification for: \(type.title)")
        }
    }
}

