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
                    Button("Fetch Reminders") {
                        AnalyticsManager.shared.logEvent("settings_selection_fetch_reminders")
                        reminderManager.fetchReminders()

                        for reminder in reminderManager.reminders {
                            InAppLogStore.shared.append("Reminder: '\(reminder.title)'", for: "Reminders", type: .reminders)
                        }
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
                            let message = granted ? "Reminder access granted" : "Reminder access denied"
                            InAppLogStore.shared.append(message, for: "Reminders", type: .reminders)
                        }
                    }
                }
            }

            Section {
                NavigationLink("Logs") {
                    InAppLogViewer(provider: "Reminders")
                }
            }
        }
    }
}
