//
//  FirebaseManager.swift
//  Focus
//
//  Created by Ryan Thomas on 4/8/25.
//

import Foundation
import FirebaseCore
import FirebaseAuth
import FirebaseFirestore
import FirebaseCrashlytics
import FirebaseMessaging
import FirebaseInAppMessaging
import UserNotifications
import UIKit

final class FirebaseManager: NSObject, ObservableObject {
    static let shared = FirebaseManager()

    let auth: Auth
    let db: Firestore

    private override init() {
        // Configure Firebase
        if FirebaseApp.app() == nil {
            FirebaseApp.configure()
        }

        self.auth = Auth.auth()
        self.db = Firestore.firestore()

        super.init()

        Messaging.messaging().delegate = self
        UNUserNotificationCenter.current().delegate = self

//        requestNotificationPermissions()
    }

    func requestNotificationPermissions() {
        print("🔧 Requesting notification permissions...")
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if let error = error {
                print("❌ Notification permission error: \(error.localizedDescription)")
                return
            }

            print("📩 Notification permission granted: \(granted)")

            guard granted else { return }

            DispatchQueue.main.async {
                UIApplication.shared.registerForRemoteNotifications()
                print("📬 Called registerForRemoteNotifications()")
            }
        }
    }

    func handleDeviceToken(_ deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
        print("📲 APNs token passed to Firebase Messaging.")
    }

    func signInAnonymously(completion: @escaping (Result<User, Error>) -> Void) {
        auth.signInAnonymously { result, error in
            if let error = error {
                completion(.failure(error))
            } else if let user = result?.user {
                completion(.success(user))
            }
        }
    }

    func signOut() {
        do {
            try auth.signOut()
        } catch {
            print("Error signing out: \(error)")
        }
    }


    func logCrash(_ message: String) {
        Crashlytics.crashlytics().log(message)
    }
}

// MARK: - Firebase Messaging Delegate
extension FirebaseManager: MessagingDelegate {
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        print("✅ FCM registration token: \(fcmToken ?? "nil")")

        // TODO: send token to backend if needed
    }
}

// MARK: - UNUserNotificationCenterDelegate
extension FirebaseManager: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        print("📨 Notification received in foreground: \(notification.request.content.userInfo)")
        completionHandler([.banner, .sound, .badge])
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        print("📲 User tapped notification: \(response.notification.request.content.userInfo)")
        completionHandler()
    }
}
