//
//  ContentView.swift
//  Focus
//
//  Created by Ryan Thomas on 4/5/25.

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            FocusListView()
                .tabItem {
                    Label("Focus", systemImage: "target")
                }

            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gearshape")
                }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}
