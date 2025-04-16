//
//  AuthViewModel.swift
//  Focus
//
//  Created by Ryan Thomas on 4/9/25.
//


import FirebaseAuth
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

}
