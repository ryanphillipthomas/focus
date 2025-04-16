//
//  ProductivityStyleStep.swift
//  Focus
//
//  Created by Ryan Thomas on 4/5/25.
//
import SwiftUI

struct OnboardingExampleStep: View {
    @EnvironmentObject var viewModel: OnboardingModel
    @State private var selectedStyles: Set<String> = []

    let styles = ["Flow-focused", "Task-oriented", "Flexible"]

    var body: some View {
        VStack {
            Text("How do you like to work?").font(.title2)

            ForEach(styles, id: \.self) { style in
                Button(action: {
                    AnalyticsManager.shared.logEvent("onboarding_selection_work")

                    if selectedStyles.contains(style) {
                        selectedStyles.remove(style)
                        InAppLogStore.shared.append("Deselected style: \(style)", for: "Onboarding", type: .onboarding)
                    } else {
                        selectedStyles.insert(style)
                        InAppLogStore.shared.append("Selected style: \(style)", for: "Onboarding", type: .onboarding)
                    }
                }) {
                    HStack {
                        Text(style)
                        Spacer()
                        if selectedStyles.contains(style) {
                            Image(systemName: "checkmark")
                        }
                    }
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(10)
                }
            }

            Spacer()

            Button("Next") {
                AnalyticsManager.shared.logEvent("onboarding_selection_next")

                let selected = Array(selectedStyles)
                viewModel.productivityStyle = selected

                InAppLogStore.shared.append("Submitted styles: \(selected.joined(separator: ", "))", for: "Onboarding", type: .onboarding)

                viewModel.next()
            }
            .disabled(selectedStyles.isEmpty)
        }
        .padding()
        .analyticsScreen(self)
    }
}
