//
//  FocusApp.swift
//  Focus
//
//  Created by Ryan Thomas on 4/5/25.
//

import SwiftUI
import SwiftData

@main
struct FocusApp: App {
    @AppStorage("hasCompletedOnboarding") var hasCompletedOnboarding = false
    
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Item.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            if hasCompletedOnboarding {
                ContentView()
            } else {
                OnboardingFlowView()
            }
        }
        .modelContainer(sharedModelContainer)
    }
}
