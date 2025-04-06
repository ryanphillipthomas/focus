//
//  CalendarListViewModel.swift
//  Focus
//
//  Created by Ryan Thomas on 4/6/25.
//


import EventKit
import SwiftUI

class CalendarListViewModel: ObservableObject {
    private let eventStore = EKEventStore()
    
    @Published var calendars: [EKCalendar] = []
    @Published var selectedCalendarID: String {
        didSet {
            UserDefaults.standard.set(selectedCalendarID, forKey: "selectedCalendarID")
        }
    }

    init() {
        self.selectedCalendarID = UserDefaults.standard.string(forKey: "selectedCalendarID") ?? ""
        loadCalendars()
    }

    func loadCalendars() {
        calendars = eventStore.calendars(for: .event)
    }

    func isSelected(_ calendar: EKCalendar) -> Bool {
        calendar.calendarIdentifier == selectedCalendarID
    }

    func selectCalendar(_ calendar: EKCalendar) {
        selectedCalendarID = calendar.calendarIdentifier
    }

    func selectedCalendarTitle() -> String {
        calendars.first(where: { $0.calendarIdentifier == selectedCalendarID })?.title ?? "None Selected"
    }
}
