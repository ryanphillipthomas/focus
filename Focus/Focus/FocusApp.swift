//
//  FocusApp.swift
//  Focus
//
//  Created by Ryan Thomas on 4/5/25.
//

import SwiftUI
import SwiftData
import FirebaseCore
import FirebaseMessaging
import UserNotifications

@main
struct FocusApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    @AppStorage("hasCompletedOnboarding") var hasCompletedOnboarding = false
    @AppStorage("accentColorName") private var accentColorName: String = AccentColorOption.blue.rawValue
    
    var accentColor: Color {
        AccentColorOption(rawValue: accentColorName)?.color ?? .blue
    }
    
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Item.self,
        ])
        let modelConfiguration = ModelConfiguration(
            schema: schema,
            isStoredInMemoryOnly: false)
//
//        let modelConfiguration = ModelConfiguration(
//            schema: schema,
//            cloudKitDatabase: .private("iCloud.com.ryanthomas.focus")
//        )

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
                    .accentColor(accentColor)
                    .onAppear {
                        _ = FirebaseManager.shared // ✅ Trigger setup once
                    }
            } else {
                OnboardingFlowView()
                    .onAppear {
                        _ = FirebaseManager.shared // ✅ Trigger setup once
                    }
            }
        }
        .modelContainer(sharedModelContainer)
    }
}
