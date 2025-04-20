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
            Section(header: Text("User Info")) {
                if let displayName = auth.user?.displayName {
                    HStack {
                        Text("Name")
                        Spacer()
                        Text(displayName)
                            .foregroundColor(.secondary)
                    }
                }
                
                if let email = auth.user?.email {
                    HStack {
                        Text("Email")
                        Spacer()
                        Text(email)
                            .foregroundColor(.secondary)
                    }
                }
                
                if let photoURL = auth.user?.photoURL {
                    HStack {
                        Text("Profile Photo")
                        Spacer()
                        AsyncImage(url: photoURL) { phase in
                            switch phase {
                            case .empty:
                                ProgressView()
                            case .success(let image):
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 40, height: 40)
                                    .clipShape(Circle())
                            case .failure:
                                Image(systemName: "person.crop.circle.badge.exclam")
                            @unknown default:
                                EmptyView()
                            }
                        }
                    }
                }
            }
            
            Section(header: Text("Authentication")) {
                if (auth.user != nil) {
                    Button(role: .destructive) {
                        auth.signOut()
                    } label: {
                        Label("Log Out", systemImage: "arrow.backward.square")
                    }
                } else {
                    Button(role: .none) {
                        if let topVC = UIApplication.shared.topViewController() {
                            auth.signInWithGoogle(presenting: topVC)
                        }
                    } label: {
                        Label("Sign In with Google", systemImage: "arrow.backward.square")
                    }
                }
                NavigationLink("Logs") {
                    InAppLogViewer(provider: "Auth")
                }
            }
            
            NavigationLink("Login View") {
                AuthView(auth: auth)
            }
        }
    }
}
