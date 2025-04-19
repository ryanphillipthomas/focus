//
//  CharacterTestView.swift
//  Focus
//
//  Created by Ryan Thomas on 4/19/25.
//


import SwiftUI

struct CharacterTestView: View {
    @StateObject private var viewModel = CharacterViewModel()

    var body: some View {
        VStack(spacing: 20) {
            Button("Fetch Luke Skywalker") {
                Task {
                    await viewModel.getPerson1()
                }
            }

            if let character = viewModel.character {
                VStack {
                    Text("⭐️ \(character.name)")
                        .font(.title)
                    Text("Birth Year: \(character.birth_year)")
                    Text("Gender: \(character.gender.capitalized)")
                }
            }

            if let error = viewModel.errorMessage {
                Text("❌ \(error)")
                    .foregroundColor(.red)
            }

            Spacer()
        }
        .padding()
        .navigationTitle("SWAPI Test")
    }
}
