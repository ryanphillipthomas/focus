//
//  HealthStatsListView.swift
//  Focus
//
//  Created by Ryan Thomas on 4/14/25.
//


import SwiftUI

struct HealthStatsListView: View {
    @StateObject private var healthManager = HealthManager()

    var body: some View {
        List {
            if healthManager.isAuthorized {
                Section {
                    NavigationLink("Logs") {
                        InAppLogViewer(provider: "Apple Health")
                    }
                    Button("Refresh Health Data") {
                        Task {
                            AnalyticsManager.shared.logEvent("settings_selection_refresh_health")
                            await healthManager.fetchHealthData()
                        }
                    }
                }
            } else {
                Section {
                    NavigationLink("Logs") {
                        InAppLogViewer(provider: "Apple Health")
                    }
                    Button("Connect Apple Health") {
                        Task {
                            AnalyticsManager.shared.logEvent("settings_selection_connect_health")
                            await healthManager.requestAuthorization()
                        }
                    }
                }
            }
        }
    }
}
