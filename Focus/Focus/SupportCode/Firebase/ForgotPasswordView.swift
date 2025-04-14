//
//  ForgotPasswordView.swift
//  Focus
//
//  Created by Ryan Thomas on 4/13/25.
//
import SwiftUI

struct ForgotPasswordView: View {
    @Environment(AuthViewModel.self) private var authViewModel
    @Environment(\.dismiss) private var dismiss

    @State private var email = ""
    @State private var message: String?

    var body: some View {
        NavigationStack {
            Form {
                Section("Reset Password") {
                    TextField("Email", text: $email)
                        .keyboardType(.emailAddress)
                        .textContentType(.emailAddress)

                    if let message = message {
                        Text(message)
                            .foregroundColor(.gray)
                    }

                    Button("Send Reset Email") {
                        Task {
                            await authViewModel.resetPassword(email: email)
                            message = "If this email is registered, a reset link has been sent."
                        }
                    }
                }
            }
            .navigationTitle("Forgot Password")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }
}
