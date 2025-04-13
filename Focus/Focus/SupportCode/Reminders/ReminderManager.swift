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
            }
        }
    }

    func checkAuthorizationStatus() {
        let status = EKEventStore.authorizationStatus(for: .reminder)
        isAuthorized = (status == .fullAccess)
    }

    func fetchReminders() {
        guard isAuthorized else { return }

        let predicate = eventStore.predicateForReminders(in: nil)
        eventStore.fetchReminders(matching: predicate) { reminders in
            DispatchQueue.main.async {
                self.reminders = reminders ?? []
            }
        }
    }

    func addReminder(title: String, dueDate: Date?) {
        guard isAuthorized else { return }

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
            fetchReminders()
        } catch {
            print("❌ Failed to save reminder: \(error)")
        }
    }
}
