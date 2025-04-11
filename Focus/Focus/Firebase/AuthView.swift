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

    var body: some View {
        VStack(spacing: 16) {
            TextField("Email", text: $email).textFieldStyle(.roundedBorder)
            SecureField("Password", text: $password).textFieldStyle(.roundedBorder)

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
    }
}


