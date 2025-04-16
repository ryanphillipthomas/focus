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
            InAppLogStore.shared.append("Firebase configured", for: "Firebase", type: .startup)
        }

        self.auth = Auth.auth()
        self.db = Firestore.firestore()

        super.init()

        Messaging.messaging().delegate = self
        UNUserNotificationCenter.current().delegate = self

        InAppLogStore.shared.append("FirebaseManager initialized", for: "Firebase", type: .startup)
    }

    func requestNotificationPermissions() {
        InAppLogStore.shared.append("Requesting notification permissions...", for: "Notifications", type: .notifications)

        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if let error = error {
                let message = "Notification permission error: \(error.localizedDescription)"
                InAppLogStore.shared.append(message, for: "Notifications", type: .notifications)
                return
            }

            InAppLogStore.shared.append("Notification permission \(granted ? "granted" : "denied")", for: "Notifications", type: .notifications)

            guard granted else { return }

            DispatchQueue.main.async {
                UIApplication.shared.registerForRemoteNotifications()
                InAppLogStore.shared.append("Called registerForRemoteNotifications()", for: "Notifications", type: .notifications)
            }
        }
    }

    func handleDeviceToken(_ deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
        InAppLogStore.shared.append("APNs token passed to Firebase Messaging.", for: "Notifications", type: .notifications)
    }

    func signInAnonymously(completion: @escaping (Result<User, Error>) -> Void) {
        auth.signInAnonymously { result, error in
            if let error = error {
                InAppLogStore.shared.append("Anonymous sign-in failed: \(error.localizedDescription)", for: "Auth", type: .authentication)
                completion(.failure(error))
            } else if let user = result?.user {
                InAppLogStore.shared.append("Anonymous sign-in succeeded. UID: \(user.uid)", for: "Auth", type: .authentication)
                completion(.success(user))
            }
        }
    }

    func signOut() {
        do {
            try auth.signOut()
            InAppLogStore.shared.append("Signed out", for: "Auth", type: .authentication)
        } catch {
            InAppLogStore.shared.append("Error signing out: \(error.localizedDescription)", for: "Auth", type: .authentication)
        }
    }

    func logCrash(_ message: String) {
        Crashlytics.crashlytics().log(message)
        InAppLogStore.shared.append("Crash logged: \(message)", for: "Crash", type: .crash)
    }
}

// MARK: - Firebase Messaging Delegate
extension FirebaseManager: MessagingDelegate {
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        let token = fcmToken ?? "nil"
        InAppLogStore.shared.append("FCM registration token received: \(token)", for: "Notifications", type: .notifications)
    }
}

// MARK: - UNUserNotificationCenterDelegate
extension FirebaseManager: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let info = notification.request.content.userInfo
        InAppLogStore.shared.append("Notification received in foreground: \(info)", for: "Notifications", type: .notifications)
        completionHandler([.banner, .sound, .badge])
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        let info = response.notification.request.content.userInfo
        InAppLogStore.shared.append("User tapped notification: \(info)", for: "Notifications", type: .notifications)
        completionHandler()
    }
}
