//
//  CalendarManager.swift
//  Focus
//
//  Created by Ryan Thomas on 4/5/25.
//
import EventKit

class CalendarManager: ObservableObject {
    private let eventStore = EKEventStore()

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
        }
    }


    func requestAccess(completion: @escaping (Bool) -> Void) {
        if #available(iOS 17.0, *) {
            // Choose full or write-only access — full is usually what you want
            eventStore.requestFullAccessToEvents { granted, error in
                DispatchQueue.main.async {
                    self.checkAuthorizationStatus()
                    completion(granted)
                }
            }
        } else {
            eventStore.requestAccess(to: .event) { granted, error in
                DispatchQueue.main.async {
                    self.checkAuthorizationStatus()
                    completion(granted)
                }
            }
        }
    }

    func createTestEvent() {
        guard isAuthorized else { return }

        let event = EKEvent(eventStore: eventStore)
        event.title = "Focus Session"
        event.startDate = Date()
        event.endDate = Date().addingTimeInterval(60 * 25) // 25 minutes
        event.calendar = eventStore.defaultCalendarForNewEvents

        do {
            try eventStore.save(event, span: .thisEvent)
            print("✅ Event created")
        } catch {
            print("❌ Failed to create event: \(error)")
        }
    }
}
