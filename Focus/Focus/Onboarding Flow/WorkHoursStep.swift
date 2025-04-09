//
//  Untitled.swift
//  Focus
//
//  Created by Ryan Thomas on 4/5/25.
//
import SwiftUI

// Work Hours Step
struct WorkHoursStep: View {
    @EnvironmentObject var viewModel: OnboardingViewModel
    @State private var startHour = Date()
    @State private var endHour = Date().addingTimeInterval(3600 * 8)

    var body: some View {
        VStack(spacing: 20) {
            Text("When do you usually work?").font(.title2)
            DatePicker("Start", selection: $startHour, displayedComponents: .hourAndMinute)
            DatePicker("End", selection: $endHour, displayedComponents: .hourAndMinute)

            Button("Next") {
                AnalyticsManager.shared.logEvent("onboarding_selection_next")
                viewModel.workHours["Weekday"] = (startHour, endHour)
                viewModel.next()
            }
            .buttonStyle(.borderedProminent)

            Spacer()
        }
        .padding()
    }
}
