//
//  CharacterTestView.swift
//  Focus
//
//  Created by Ryan Thomas on 4/19/25.
//


import SwiftUI

struct CharacterTestView: View {
    @StateObject private var characterViewModel = CharacterViewModel()
    @StateObject private var openAIViewModel = OpenAIViewModel()
    @State private var input: String = ""
    
    
    var body: some View {
        List {
            Section(header: Text("API")) {
                NavigationLink("Logs") {
                    InAppLogViewer(provider: "API")
                }
                
                Button("Fetch Luke Skywalker") {
                    AnalyticsManager.shared.logEvent("settings_selection_get_luke_skywalker")
                                                     Task {
                        await characterViewModel.getPerson1()
                    }
                }
            }
        }
    }
}


//    var body: some View {
//        List() {
//            Button("Fetch Luke Skywalker") {
//                Task {
//                    await characterViewModel.getPerson1()
//                }
//            }
//
//            if let character = characterViewModel.character {
//                VStack {
//                    Text("⭐️ \(character.name)")
//                        .font(.title)
//                    Text("Birth Year: \(character.birth_year)")
//                    Text("Gender: \(character.gender.capitalized)")
//                }
//            }
//
//            if let error = characterViewModel.errorMessage {
//                Text("❌ \(error)")
//                    .foregroundColor(.red)
//            }
//
//            Spacer()
//            
//            VStack(spacing: 20) {
//                TextField("Ask something...", text: $input)
//                    .textFieldStyle(.roundedBorder)
//
//                Button("Send") {
//                    Task {
//                        await openAIViewModel.sendPrompt(input)
//                    }
//                }
//
//                if openAIViewModel.isLoading {
//                    ProgressView("Thinking...")
//                }
//
//                if let response = openAIViewModel.response {
//                    Text(response)
//                        .padding()
//                }
//
//                if let error = openAIViewModel.error {
//                    Text("Error: \(error)")
//                        .foregroundColor(.red)
//                }
//            }
//        }
//        .padding()
//        .navigationTitle("SWAPI Test")
//    }
//}
