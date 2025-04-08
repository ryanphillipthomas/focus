//
//  FirebaseManager.swift
//  Focus
//
//  Created by Ryan Thomas on 4/8/25.
//


import FirebaseCore
import FirebaseAnalytics
import FirebaseAuth
import FirebaseFirestore
import FirebaseCrashlytics
import FirebaseMessaging

final class FirebaseManager: NSObject, ObservableObject {
    static let shared = FirebaseManager()
    
    let auth: Auth
    let db: Firestore
    var user: User? { auth.currentUser }
    
    private override init() {
        self.auth = Auth.auth()
        self.db = Firestore.firestore()
        
        super.init()
        Messaging.messaging().delegate = self
        
        // Optional: Listen for auth changes
        auth.addStateDidChangeListener { _, user in
            print("Auth state changed. User: \(String(describing: user))")
        }
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
    
    func logEvent(_ name: String, parameters: [String: Any]? = nil) {
        Analytics.logEvent(name, parameters: parameters)
    }
    
    func logCrash(_ message: String) {
        Crashlytics.crashlytics().log(message)
    }
}

// MARK: - Messaging Delegate
extension FirebaseManager: MessagingDelegate {
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        print("FCM Token: \(fcmToken ?? "")")
        // You could send this token to your server if needed
    }
}
