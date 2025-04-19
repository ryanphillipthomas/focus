//
//  AuthenticationListView.swift
//  Focus
//
//  Created by Ryan Thomas on 4/14/25.
//


import SwiftUI
import GoogleSignInSwift

struct AuthenticationListView: View {
    @ObservedObject var auth: AuthViewModel

    var body: some View {
        List {
            Section(header: Text("Authentication")) {
                NavigationLink("Login") {
                    AuthView(auth: auth)
                }
                Button(role: .destructive) {
                    auth.signOut()
                } label: {
                    Label("Log Out", systemImage: "arrow.backward.square")
                }
            }
            Section(){
                GoogleSignInButton {
                    if let topVC = UIApplication.shared.topViewController() {
                        auth.signInWithGoogle(presenting: topVC)
                    }
                }
                .frame(height: 50)
                .padding()
            }
            NavigationLink("Logs") {
                InAppLogViewer(provider: "Auth")
            }
        }
    }
}
