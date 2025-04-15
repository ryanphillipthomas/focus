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
                NavigationLink("Firebase Logs") {
                    InAppLogViewer(provider: "Firebase")
                }
                NavigationLink("Mixpanel Logs") {
                    InAppLogViewer(provider: "Mixpanel")
                }
            }
        }
    }
}
