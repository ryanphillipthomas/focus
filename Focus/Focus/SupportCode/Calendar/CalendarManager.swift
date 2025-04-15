//
//  CalendarManager.swift
//  Focus
//
//  Created by Ryan Thomas on 4/5/25.
//
import EventKit

class CalendarManager: ObservableObject {
    let eventStore = EKEventStore()
    @Published var isAuthorized: Bool = false

    init() {
        checkAuthorizationStatus()
    }

    func checkAuthorizationStatus() {
        let status = EKEventStore.authorizationStatus(for: .event)

        DispatchQueue.main.async {
            if #available(iOS 17.0, *) {
                self.isAuthorized = (status == .fullAccess || status == .writeOnly)
            } else {
                self.isAuthorized = (status == .authorized)
            }

            let statusString: String
            switch status {
            case .notDetermined: statusString = "Not Determined"
            case .restricted:    statusString = "Restricted"
            case .denied:        statusString = "Denied"
            case .authorized:    statusString = "Authorized"
            case .fullAccess:    statusString = "Full Access"
            case .writeOnly:     statusString = "Write Only"
            @unknown default:    statusString = "Unknown"
            }

            InAppLogStore.shared.append("Calendar auth status: \(statusString)", for: "Calendar", type: .calendar)
        }
    }

    func requestAccess(completion: @escaping (Bool) -> Void) {
        if #available(iOS 17.0, *) {
            eventStore.requestFullAccessToEvents { granted, error in
                DispatchQueue.main.async {
                    self.checkAuthorizationStatus()

                    if let error = error {
                        InAppLogStore.shared.append("Calendar access error: \(error.localizedDescription)", for: "Calendar", type: .calendar)
                    } else {
                        let result = granted ? "granted" : "denied"
                        InAppLogStore.shared.append("Calendar access \(result) (Full Access).", for: "Calendar", type: .calendar)
                    }

                    completion(granted)
                }
            }
        } else {
            eventStore.requestAccess(to: .event) { granted, error in
                DispatchQueue.main.async {
                    self.checkAuthorizationStatus()

                    if let error = error {
                        InAppLogStore.shared.append("Calendar access error: \(error.localizedDescription)", for: "Calendar", type: .calendar)
                    } else {
                        let result = granted ? "granted" : "denied"
                        InAppLogStore.shared.append("Calendar access \(result).", for: "Calendar", type: .calendar)
                    }

                    completion(granted)
                }
            }
        }
    }

    func createTestEvent() {
        guard isAuthorized else {
            InAppLogStore.shared.append("Attempted to create event without authorization.", for: "Calendar", type: .calendar)
            return
        }

        let event = EKEvent(eventStore: eventStore)
        event.title = "Focus Session"
        event.startDate = Date()
        event.endDate = Date().addingTimeInterval(60 * 25)
        event.calendar = eventStore.defaultCalendarForNewEvents

        do {
            try eventStore.save(event, span: .thisEvent)
            let formattedStart = DateFormatter.localizedString(from: event.startDate, dateStyle: .none, timeStyle: .short)
            let formattedEnd = DateFormatter.localizedString(from: event.endDate, dateStyle: .none, timeStyle: .short)
            let calendarName = event.calendar.title

            InAppLogStore.shared.append(
                "Created event '\(event.title ?? "Unnamed")' from \(formattedStart) to \(formattedEnd) on '\(calendarName)'.",
                for: "Calendar",
                type: .calendar
            )
        } catch {
            InAppLogStore.shared.append("Failed to create event: \(error.localizedDescription)", for: "Calendar", type: .calendar)
        }
    }

    // MARK: - Placeholder for updating an event
    func updateEvent(eventIdentifier: String, newTitle: String) {
        guard let event = eventStore.event(withIdentifier: eventIdentifier) else {
            InAppLogStore.shared.append("Failed to update: Event not found for ID \(eventIdentifier)", for: "Calendar", type: .calendar)
            return
        }

        event.title = newTitle

        do {
            try eventStore.save(event, span: .thisEvent)
            InAppLogStore.shared.append("Updated event title to '\(newTitle)' for event on '\(event.calendar.title)'.", for: "Calendar", type: .calendar)
        } catch {
            InAppLogStore.shared.append("Failed to update event: \(error.localizedDescription)", for: "Calendar", type: .calendar)
        }
    }

    // MARK: - Placeholder for deleting an event
    func deleteEvent(eventIdentifier: String) {
        guard let event = eventStore.event(withIdentifier: eventIdentifier) else {
            InAppLogStore.shared.append("Failed to delete: Event not found for ID \(eventIdentifier)", for: "Calendar", type: .calendar)
            return
        }

        do {
            try eventStore.remove(event, span: .thisEvent)
            InAppLogStore.shared.append("Deleted event '\(event.title ?? "Unnamed")' from '\(event.calendar.title)'.", for: "Calendar", type: .calendar)
        } catch {
            InAppLogStore.shared.append("Failed to delete event: \(error.localizedDescription)", for: "Calendar", type: .calendar)
        }
    }
}
