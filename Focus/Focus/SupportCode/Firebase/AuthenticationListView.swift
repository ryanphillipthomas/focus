//
//  AuthenticationListView.swift
//  Focus
//
//  Created by Ryan Thomas on 4/14/25.
//


import SwiftUI

struct AuthenticationListView: View {
    @ObservedObject var auth: AuthViewModel

    var body: some View {
        List {
            Section(header: Text("Authentication")) {
                Button {
                    AuthView(auth: auth)
                } label: {
                    Label("Log In", systemImage: "arrow.forward.square")
                }

                Button(role: .destructive) {
                    auth.signOut()
                } label: {
                    Label("Log Out", systemImage: "arrow.backward.square")
                }
            }
        }
    }
}
