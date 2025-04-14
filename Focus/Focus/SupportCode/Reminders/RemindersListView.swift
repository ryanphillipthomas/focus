//
//  RemindersListView.swift
//  Focus
//
//  Created by Ryan Thomas on 4/14/25.
//


import SwiftUI

struct RemindersListView: View {
    @ObservedObject var reminderManager: ReminderManager

    var body: some View {
        List {
            if reminderManager.isAuthorized {
                Section {
                    Label("Connected to Reminders", systemImage: "checkmark.circle")
                        .foregroundColor(.green)

                    ForEach(reminderManager.reminders.prefix(5), id: \.calendarItemIdentifier) { reminder in
                        Text(reminder.title)
                    }

                    Button("Fetch Reminders") {
                        AnalyticsManager.shared.logEvent("settings_selection_fetch_reminders")
                        reminderManager.fetchReminders()
                    }

                    Button("Add Test Reminder") {
                        AnalyticsManager.shared.logEvent("settings_selection_add_test_reminder")
                        reminderManager.addReminder(
                            title: "Test Reminder",
                            dueDate: Date().addingTimeInterval(3600)
                        )
                    }
                }
            } else {
                Section {
                    Button("Enable Reminder Access") {
                        AnalyticsManager.shared.logEvent("settings_selection_enable_reminders")
                        reminderManager.requestAccess { granted in
                            print(granted ? "✅ Reminder access granted" : "❌ Reminder access denied")
                        }
                    }
                }
            }
        }
    }
}
