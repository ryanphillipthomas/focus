//
//  AuthView.swift
//  Focus
//
//  Created by Ryan Thomas on 4/9/25.
//
import SwiftUI

struct AuthView: View {
    @Bindable var auth: AuthViewModel
    @State var email = ""
    @State var password = ""
    @State var isLogin = true
    @State private var showForgotPasswordSheet = false
    @State private var forgotPasswordEmail = ""
    @State private var forgotPasswordMessage: String?

    var body: some View {
        VStack(spacing: 16) {
            
            TextField("Email", text: $email)
                .textFieldStyle(.roundedBorder)
                .keyboardType(.emailAddress)
                .textContentType(.username)
                .autocapitalization(.none)

            SecureField("Password", text: $password)
                .textFieldStyle(.roundedBorder)
                .textContentType(.password)

            if isLogin {
                Button("Forgot Password?") {
                    forgotPasswordEmail = email
                    showForgotPasswordSheet = true
                }
                .font(.footnote)
                .foregroundColor(.blue)
            }

            Button(isLogin ? "Login" : "Sign Up") {
                Task {
                    if isLogin {
                        await auth.signIn(email: email, password: password)
                    } else {
                        await auth.signUp(email: email, password: password)
                    }
                }
            }

            Button(isLogin ? "Need an account? Sign up" : "Have an account? Log in") {
                isLogin.toggle()
            }
            .font(.caption)

            if let error = auth.errorMessage {
                Text(error).foregroundColor(.red)
            }
        }
        .padding()
        .sheet(isPresented: $showForgotPasswordSheet) {
            NavigationStack {
                VStack(spacing: 16) {
                    TextField("Enter your email", text: $forgotPasswordEmail)
                        .textFieldStyle(.roundedBorder)
                        .keyboardType(.emailAddress)

                    if let message = forgotPasswordMessage {
                        Text(message).foregroundColor(.gray)
                    }

                    Button("Send Reset Email") {
                        Task {
                            await auth.resetPassword(email: forgotPasswordEmail)
                            forgotPasswordMessage = "If this email is registered, a reset link has been sent."
                        }
                    }

                    Button("Dismiss") {
                        showForgotPasswordSheet = false
                        forgotPasswordMessage = nil
                    }
                    .foregroundColor(.red)
                }
                .padding()
                .navigationTitle("Forgot Password")
            }
        }
    }
}



