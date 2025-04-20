//
//  AuthViewModel.swift
//  Focus
//
//  Created by Ryan Thomas on 4/9/25.
//

import GoogleSignIn
import FirebaseAuth
import FirebaseCore
import SwiftUI

@Observable
class AuthViewModel: ObservableObject {
    var user: User? = Auth.auth().currentUser
    var errorMessage: String?
    
    // 🔐 Store the listener handle here
    private var authStateHandle: AuthStateDidChangeListenerHandle?
    
    init() {
        // ✅ Assign the handle properly
        self.authStateHandle = Auth.auth().addStateDidChangeListener { _, user in
            self.user = user
        }
    }
    
    deinit {
        // ✅ Remove the listener when this view model deinitializes
        if let handle = authStateHandle {
            Auth.auth().removeStateDidChangeListener(handle)
        }
    }
    
    func signIn(email: String, password: String) async {
        do {
            let result = try await Auth.auth().signIn(withEmail: email, password: password)
            self.user = result.user
            self.errorMessage = nil
            AnalyticsManager.shared.setUser(id: result.user.uid)
            AnalyticsManager.shared.logEvent("Sign In Success", parameters: ["email": email])
            InAppLogStore.shared.append("Sign in success for \(email)", for: "Auth", type: .authentication)
        } catch {
            self.errorMessage = error.localizedDescription
            AnalyticsManager.shared.logEvent("Sign In Failed", parameters: ["email": email, "error": error.localizedDescription])
            InAppLogStore.shared.append("Sign in failed for \(email): \(error.localizedDescription)", for: "Auth", type: .authentication)
        }
    }
    
    func signUp(email: String, password: String) async {
        do {
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            self.user = result.user
            self.errorMessage = nil
            AnalyticsManager.shared.setUser(id: result.user.uid)
            AnalyticsManager.shared.logEvent("Sign Up Success", parameters: ["email": email])
            InAppLogStore.shared.append("Sign up success for \(email)", for: "Auth", type: .authentication)
        } catch {
            self.errorMessage = error.localizedDescription
            AnalyticsManager.shared.logEvent("Sign Up Failed", parameters: ["email": email, "error": error.localizedDescription])
            InAppLogStore.shared.append("Sign up failed for \(email): \(error.localizedDescription)", for: "Auth", type: .authentication)
        }
    }
    
    func signOut() {
        do {
            try Auth.auth().signOut()
            self.user = nil
            AnalyticsManager.shared.setUser(id: nil)
            AnalyticsManager.shared.logEvent("Sign Out")
            InAppLogStore.shared.append("Signed out", for: "Auth", type: .authentication)
        } catch {
            self.errorMessage = error.localizedDescription
            AnalyticsManager.shared.logEvent("Sign Out Failed", parameters: ["error": error.localizedDescription])
            InAppLogStore.shared.append("Sign out failed: \(error.localizedDescription)", for: "Auth", type: .authentication)
        }
    }
    
    func resetPassword(email: String) async {
        do {
            try await Auth.auth().sendPasswordReset(withEmail: email)
            errorMessage = nil
            AnalyticsManager.shared.logEvent("Send Password Reset")
            InAppLogStore.shared.append("Password reset sent to \(email)", for: "Auth", type: .authentication)
        } catch {
            self.errorMessage = error.localizedDescription
            AnalyticsManager.shared.logEvent("Send Password Reset Failed", parameters: ["error": error.localizedDescription])
            InAppLogStore.shared.append("Password reset failed for \(email): \(error.localizedDescription)", for: "Auth", type: .authentication)
        }
    }
    
    func signInWithGoogle(presenting viewController: UIViewController) {
        guard let clientID = FirebaseApp.app()?.options.clientID else {
            errorMessage = "Missing Firebase client ID"
            return
        }
        
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config

        // 👉 Add Gmail read-only scope
        let additionalScopes = ["https://www.googleapis.com/auth/gmail.readonly"]

        GIDSignIn.sharedInstance.signIn(withPresenting: viewController, hint: nil, additionalScopes: additionalScopes) { signInResult, error in
            if let error = error {
                self.errorMessage = error.localizedDescription
                InAppLogStore.shared.append("Google Sign-In failed: \(error.localizedDescription)", for: "Auth", type: .authentication)
                return
            }

            guard let signInResult = signInResult else {
                self.errorMessage = "No sign-in result"
                return
            }

            self.finishGoogleSignIn(user: signInResult.user)
        }
    }
    
    private func finishGoogleSignIn(user: GIDGoogleUser?) {
        guard
            let user = user,
            let idToken = user.idToken
        else {
            self.errorMessage = "Missing Google tokens"
            return
        }
        
        let accessToken = user.accessToken
        let credential = GoogleAuthProvider.credential(
            withIDToken: idToken.tokenString,
            accessToken: accessToken.tokenString
        )

        Auth.auth().signIn(with: credential) { result, error in
            if let error = error {
                self.errorMessage = error.localizedDescription
                InAppLogStore.shared.append("Firebase sign-in failed: \(error.localizedDescription)", for: "Auth", type: .authentication)
                return
            }

            self.user = result?.user
            self.errorMessage = nil

            print("✅ Gmail API Access Token: \(accessToken.tokenString)")
            AnalyticsManager.shared.setUser(id: result?.user.uid)
            InAppLogStore.shared.append("Google Sign-In success for \(result?.user.email ?? "unknown")", for: "Auth", type: .authentication)
        }
    }

    func fetchGmailInbox(using accessToken: String, completion: @escaping ([String]) -> Void) {
        let url = URL(string: "https://gmail.googleapis.com/gmail/v1/users/me/messages")!
        var request = URLRequest(url: url)
        request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("❌ Gmail API error: \(error)")
                return
            }

            guard let data = data else {
                print("❌ No data received from Gmail API")
                return
            }

            do {
                let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                let messages = json?["messages"] as? [[String: Any]] ?? []

                let messageIDs = messages.compactMap { $0["id"] as? String }
                print("✅ Fetched \(messageIDs.count) messages")
                completion(messageIDs)
            } catch {
                print("❌ Failed to parse Gmail API response: \(error)")
            }
        }.resume()
    }
    
    func fetchEmailDetail(id: String, accessToken: String) {
        let url = URL(string: "https://gmail.googleapis.com/gmail/v1/users/me/messages/\(id)?format=metadata")!
        var request = URLRequest(url: url)
        request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")

        URLSession.shared.dataTask(with: request) { data, _, error in
            if let data = data {
                print(String(data: data, encoding: .utf8) ?? "")
            }
        }.resume()
    }
}

