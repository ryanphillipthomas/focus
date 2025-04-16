//
//  ReminderManager.swift
//  Focus
//
//  Created by Ryan Thomas on 4/6/25.
//
import EventKit
import SwiftUI

class ReminderManager: ObservableObject {
    private let eventStore = EKEventStore()

    @Published var isAuthorized: Bool = false
    @Published var reminders: [EKReminder] = []

    init() {
        checkAuthorizationStatus()
    }

    func requestAccess(completion: @escaping (Bool) -> Void) {
        eventStore.requestFullAccessToReminders { granted, error in
            DispatchQueue.main.async {
                self.isAuthorized = granted
                completion(granted)

                if let error = error {
                    InAppLogStore.shared.append("Reminder access request failed: \(error.localizedDescription)", for: "Reminders", type: .reminders)
                } else {
                    InAppLogStore.shared.append("Reminder access \(granted ? "granted" : "denied")", for: "Reminders", type: .reminders)
                }
            }
        }
    }

    func checkAuthorizationStatus() {
        let status = EKEventStore.authorizationStatus(for: .reminder)
        isAuthorized = (status == .fullAccess)
        InAppLogStore.shared.append("Reminder authorization status: \(status.rawValue)", for: "Reminders", type: .reminders)
    }

    func fetchReminders() {
        guard isAuthorized else {
            InAppLogStore.shared.append("Skipped reminder fetch: not authorized", for: "Reminders", type: .reminders)
            return
        }

        let predicate = eventStore.predicateForReminders(in: nil)
        eventStore.fetchReminders(matching: predicate) { reminders in
            DispatchQueue.main.async {
                self.reminders = reminders ?? []

                let count = reminders?.count ?? 0
                InAppLogStore.shared.append("Fetched \(count) reminders", for: "Reminders", type: .reminders)
            }
        }
    }

    func addReminder(title: String, dueDate: Date?) {
        guard isAuthorized else {
            InAppLogStore.shared.append("Failed to add reminder: not authorized", for: "Reminders", type: .reminders)
            return
        }

        let reminder = EKReminder(eventStore: eventStore)
        reminder.title = title
        reminder.calendar = eventStore.defaultCalendarForNewReminders()

        if let dueDate = dueDate {
            reminder.dueDateComponents = Calendar.current.dateComponents(
                [.year, .month, .day, .hour, .minute],
                from: dueDate
            )
        }

        do {
            try eventStore.save(reminder, commit: true)
            InAppLogStore.shared.append("Added reminder: '\(title)'\(dueDate != nil ? " due at \(dueDate!)" : "")", for: "Reminders", type: .reminders)
            fetchReminders()
        } catch {
            InAppLogStore.shared.append("Failed to save reminder '\(title)': \(error.localizedDescription)", for: "Reminders", type: .reminders)
        }
    }
}
