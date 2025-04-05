//
//  SettingsView.swift
//  Focus
//
//  Created by Ryan Thomas on 4/5/25.

import SwiftUI

struct SettingsView: View {
    var body: some View {
        NavigationView {
            List {
                Text("General")
                Text("Notifications")
                Text("Account")
            }
            .navigationTitle("Settings")
        }
    }
}
