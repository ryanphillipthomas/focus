//
//  AnalyticsSettingsListView.swift
//  Focus
//
//  Created by Ryan Thomas on 4/14/25.
//


import SwiftUI

struct AnalyticsSettingsListView: View {
    var body: some View {
        List {
            Section(header: Text("Analytics")) {
                HStack {
                    Text("Firebase Analytics")
                    Spacer()
                    Text("Enabled")
                        .foregroundColor(.secondary)
                }

                HStack {
                    Text("Mixpanel Analytics")
                    Spacer()
                    Text("Enabled")
                        .foregroundColor(.secondary)
                }
            }
        }
    }
}
