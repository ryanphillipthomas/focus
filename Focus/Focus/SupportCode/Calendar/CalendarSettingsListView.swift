//
//  CalendarSettingsListView.swift
//  Focus
//
//  Created by Ryan Thomas on 4/14/25.
//


import SwiftUI

struct CalendarSettingsListView: View {
    @ObservedObject var calendarManager: CalendarManager
    @ObservedObject var calendarViewModel: CalendarListViewModel

    var body: some View {
        List {
            Section(header: Text("Calendar")) {
                Button("Enable Calendar Access") {
                    AnalyticsManager.shared.logEvent("settings_selection_enable_calendar")
                    calendarManager.requestAccess { granted in
                        print(granted ? "✅ Calendar access granted by user." : "❌ Calendar access denied by user.")
                    }
                }

                Button("Load All Calendars") {
                    AnalyticsManager.shared.logEvent("settings_selection_load_all_calendars")

                    let calendars = calendarManager.eventStore.calendars(for: .event)

                    if calendars.isEmpty {
                        InAppLogStore.shared.append("No calendars found in EKEventStore.", for: "Calendar", type: .calendar)
                    } else {
                        for calendar in calendars {
                            let editable = calendar.allowsContentModifications ? "✅ Editable" : "🚫 Read-Only"
                            let details = """
                                Calendar: \(calendar.title)
                                Source: \(calendar.source.title)
                                ID: \(calendar.calendarIdentifier)
                                \(editable)
                            """
                            InAppLogStore.shared.append(details, for: "Calendar", type: .calendar)

                            // MARK: - Log today's events
                            let startOfDay = Calendar.current.startOfDay(for: Date())
                            let endOfDay = Calendar.current.date(byAdding: .day, value: 1, to: startOfDay)!

                            let predicate = calendarManager.eventStore.predicateForEvents(withStart: startOfDay, end: endOfDay, calendars: [calendar])
                            let events = calendarManager.eventStore.events(matching: predicate)

                            if events.isEmpty {
                                InAppLogStore.shared.append("No events today in '\(calendar.title)'", for: "Calendar", type: .calendar)
                            } else {
                                for event in events {
                                    let start = DateFormatter.localizedString(from: event.startDate, dateStyle: .none, timeStyle: .short)
                                    let end = DateFormatter.localizedString(from: event.endDate, dateStyle: .none, timeStyle: .short)
                                    let location = event.location ?? "No location"
                                    let summary = "📅 '\(event.title ?? "Untitled")' from \(start)–\(end) @ \(location)"
                                    InAppLogStore.shared.append(summary, for: "Calendar", type: .calendar)
                                }
                            }
                        }
                    }

                    calendarViewModel.loadCalendars()
                }



                if calendarManager.isAuthorized {
                    Button("Create Test Event") {
                        AnalyticsManager.shared.logEvent("settings_selection_create_test_event")
                        calendarManager.createTestEvent()
                    }
                }

                NavigationLink("Logs") {
                    InAppLogViewer(provider: "Calendar")
                }
            }
        }
    }
}
