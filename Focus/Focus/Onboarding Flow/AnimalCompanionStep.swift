//
//  AnimalCompanionStep.swift
//  Focus
//
//  Created by Ryan Thomas on 4/5/25.
//
import SwiftUI
// Animal Companion Step
struct AnimalCompanionStep: View {
    @EnvironmentObject var viewModel: OnboardingViewModel
    @State private var selectedAnimal: String = "Fox"

    let animals = ["Fox", "Owl", "Bear (Premium)", "Cat (Premium)"]

    var body: some View {
        VStack(spacing: 20) {
            Text("Pick your productivity partner").font(.title2)
            Text("Each animal reacts as you complete tasks. More coming soon!")
                .multilineTextAlignment(.center)

            ForEach(animals, id: \.self) { animal in
                Button(action: {
                    AnalyticsManager.shared.logEvent("onboarding_selection_animal")
                    selectedAnimal = animal
                }) {
                    HStack {
                        Text(animal)
                        Spacer()
                        if selectedAnimal == animal {
                            Image(systemName: "checkmark")
                        }
                    }
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(10)
                }
            }

            Button("Next") {
                viewModel.selectedAnimal = selectedAnimal
                viewModel.next()
            }
            .buttonStyle(.borderedProminent)

            Spacer()
        }
        .padding()
    }
}
