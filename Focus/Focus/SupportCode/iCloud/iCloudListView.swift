//
//  iCloudListView.swift
//  Focus
//
//  Created by Ryan Thomas on 4/14/25.
//


import SwiftUI

struct iCloudListView: View {
    @ObservedObject var iCloudStatus: iCloudStatusManager

    var body: some View {
        List {
            Section(header: Text("iCloud")) {
                NavigationLink("Logs") {
                    InAppLogViewer(provider: "iCloud")
                }

                Button("Refresh iCloud Status") {
                    AnalyticsManager.shared.logEvent("settings_selection_refresh_icloud")
                    iCloudStatus.checkiCloudStatus()
                }
            }
        }
    }
}
