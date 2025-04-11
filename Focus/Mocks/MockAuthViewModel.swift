//
//  MockAuthViewModel.swift
//  Focus
//
//  Created by Ryan Thomas on 4/10/25.
//


import Foundation
import Combine

final class MockAuthViewModel: AuthViewModel {
    var signInCalled = false
    var signUpCalled = false
    var signOutCalled = false

    override func signIn(email: String, password: String) async {
        signInCalled = true
        // Simulate an error if desired
        await MainActor.run {
            self.errorMessage = "Mock Sign In Error"
        }
    }

    override func signUp(email: String, password: String) async {
        signUpCalled = true
        await MainActor.run {
            self.errorMessage = "Mock Sign Up Error"
        }
    }

    override func signOut() {
        signOutCalled = true
        // Optional: simulate success or error
        self.errorMessage = nil
    }
}
