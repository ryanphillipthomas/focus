//
//  GmailLogTriggerView.swift
//  Focus
//
//  Created by Ryan Thomas on 4/19/25.
//


import SwiftUI

struct GmailLogTriggerView: View {
    let accessToken: String?

    var body: some View {
        List {
            Section(header: Text("Gmail Integration")) {
                Button {
                    guard let token = accessToken else {
                        InAppLogStore.shared.append("No access token available", for: "Gmail", type: .authentication)
                        return
                    }
                    InAppLogStore.shared.append("Starting Gmail fetch...", for: "Gmail", type: .authentication)
                    GmailViewModel().fetchAndLogInbox(accessToken: token)
                } label: {
                    Label("Fetch Gmail", systemImage: "envelope.badge")
                }
                .disabled(accessToken == nil)
            }

            Section {
                NavigationLink(destination: InAppLogViewer(provider: "Gmail")) {
                    Label("View Logs", systemImage: "doc.plaintext")
                }
            }
        }
        .navigationTitle("Gmail Tools")
    }
}
