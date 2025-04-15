//
//  CacheSettingsListView.swift
//  Focus
//
//  Created by Ryan Thomas on 4/14/25.
//


import SwiftUI
import SwiftData

struct CacheSettingsListView: View {
    
    @Environment(\.modelContext) private var modelContext
    @Query private var focusItems: [Item] // Replace with your model name
    
    var body: some View {
        List {
            Section(header: Text("Cache")) {
                Button("Reset Focus List") {
                    AnalyticsManager.shared.logEvent("settings_selection_reset_focus_list")
                    resetFocusItems()
                }
                .foregroundColor(.red)
            }
        }
    }
    
    private func resetFocusItems() {
        for item in focusItems {
            modelContext.delete(item)
        }

        do {
            try modelContext.save()
        } catch {
            print("❌ Failed to delete focus items: \(error)")
        }
    }
}
