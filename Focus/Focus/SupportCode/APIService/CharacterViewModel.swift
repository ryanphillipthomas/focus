//
//  CharacterViewModel.swift
//  Focus
//
//  Created by Ryan Thomas on 4/19/25.
//


import Foundation
import FirebaseCrashlytics

@MainActor
class CharacterViewModel: ObservableObject {
    @Published var character: Character?
    @Published var errorMessage: String?

    func getPerson1() async {
        do {
            let response: CharacterResponse = try await APIManager.shared.get("people/1", responseType: CharacterResponse.self)
            let fetched = response.result.properties

            character = fetched
            errorMessage = nil

            APILogger.log("Fetched character: \(fetched.name), born \(fetched.birth_year)")

        } catch {
            let message = "Failed to fetch character: \(error.localizedDescription)"
            errorMessage = message
            APILogger.log("\(message)")
            Crashlytics.crashlytics().record(error: error)
        }
    }
}
