//
//  NotificationTestView.swift
//  Focus
//
//  Created by Ryan Thomas on 4/7/25.
//

import SwiftUI
import UserNotifications


struct NotificationTestView: View {
    @Environment(\.dismiss) private var dismiss // lets you close the sheet

    var body: some View {
        NavigationStack {
            List {
                Section {
                    Button("Request Permission") {
                        requestNotificationPermission()
                    }
                }

                Section(header: Text("Test Notifications")) {
                    ForEach(UserNotificationPreferences.defaultPreferences.preferences, id: \.id) { type in
                        Button("Send: \(type.title)") {
                            scheduleTestNotification(type: type)
                        }
                    }
                }
            }
            .navigationTitle("Notification Tester")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
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

func requestNotificationPermission() {
    UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
        if let error = error {
            print("Error requesting notification permission: \(error)")
        } else {
            print("Permission granted: \(granted)")
        }
    }
}

