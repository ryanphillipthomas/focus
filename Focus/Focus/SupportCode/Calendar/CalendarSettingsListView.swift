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
                Button("Choose Calendar") {
                    AnalyticsManager.shared.logEvent("settings_selection_choose_calendar")
                    CalendarListView(viewModel: calendarViewModel)
                }

                HStack {
                    Text("Selected Calendar")
                    Spacer()
                    Text(calendarViewModel.selectedCalendarTitle())
                        .foregroundColor(.secondary)
                }

                if calendarManager.isAuthorized {
                    Label("Connected to Calendar", systemImage: "checkmark.circle")
                        .foregroundColor(.green)
                } else {
                    Button("Enable Calendar Access") {
                        AnalyticsManager.shared.logEvent("settings_selection_enable_calendar")
                        calendarManager.requestAccess { granted in
                            print(granted ? "✅ Calendar access granted by user." : "❌ Calendar access denied by user.")
                        }
                    }
                }
            }
        }
    }
}
