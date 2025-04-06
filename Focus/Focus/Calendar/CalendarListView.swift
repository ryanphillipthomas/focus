//
//  CalendarListView.swift
//  Focus
//
//  Created by Ryan Thomas on 4/6/25.
//


import SwiftUI
import EventKit

struct CalendarListView: View {
    @ObservedObject var viewModel: CalendarListViewModel
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        List(viewModel.calendars, id: \.calendarIdentifier) { calendar in
            Button(action: {
                viewModel.selectCalendar(calendar)
                dismiss()
            }) {
                HStack {
                    Circle()
                        .fill(Color(calendar.cgColor ?? UIColor.systemBlue.cgColor))
                        .frame(width: 10, height: 10)

                    Text(calendar.title)
                        .foregroundColor(.primary)

                    Spacer()

                    if viewModel.isSelected(calendar) {
                        Image(systemName: "checkmark")
                            .foregroundColor(.accentColor)
                    }
                }
            }
        }
        .navigationTitle("Select Calendar")
    }
}
