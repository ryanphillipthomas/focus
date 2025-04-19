//
//  GmailLogTriggerView.swift
//  Focus
//
//  Created by Ryan Thomas on 4/19/25.
//


import SwiftUI

struct GmailLogTriggerView: View {
    let accessToken: String

    var body: some View {
        List {
            Section(header: Text("Gmail Integration")) {
                Button {
                    InAppLogStore.shared.append("🔄 Starting Gmail fetch...", for: "Gmail", type: .authentication)
                    GmailViewModel().fetchAndLogInbox(accessToken: accessToken)
                } label: {
                    Label("Fetch Gmail Logs", systemImage: "envelope.badge")
                }
            }

            Section {
                NavigationLink(destination: InAppLogViewer()) {
                    Label("View Logs", systemImage: "doc.plaintext")
                }
            }
        }
        .navigationTitle("Gmail Tools")
    }
}
