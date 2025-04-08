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

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()
    return true
  }
    
    func application(_ application: UIApplication,
                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
    }
}

@main
struct FocusApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
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
            } else {
                OnboardingFlowView()
            }
        }
        .modelContainer(sharedModelContainer)
    }
}
