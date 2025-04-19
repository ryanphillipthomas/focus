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
                    .environmentObject(ThemeModel()) // 👈 This is the fix
            } else {
                OnboardingFlow()
                    .onAppear {
                        _ = FirebaseManager.shared // ✅ Trigger setup once
                    }
            }
        }
        .modelContainer(sharedModelContainer)
    }
}

extension UIApplication {
    func topViewController(base: UIViewController? = nil) -> UIViewController? {
        let base = base ?? UIApplication.shared.connectedScenes
            .compactMap { ($0 as? UIWindowScene)?.keyWindow }
            .first?.rootViewController

        if let nav = base as? UINavigationController {
            return topViewController(base: nav.visibleViewController)
        } else if let tab = base as? UITabBarController,
                  let selected = tab.selectedViewController {
            return topViewController(base: selected)
        } else if let presented = base?.presentedViewController {
            return topViewController(base: presented)
        }

        return base
    }
}
