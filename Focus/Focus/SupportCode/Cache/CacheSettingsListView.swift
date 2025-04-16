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
            Section(){
                NavigationLink("Logs"){
                    InAppLogViewer(provider: "Cache")
                }
            }
        }
    }
    
    private func resetFocusItems() {
        let count = focusItems.count

        for item in focusItems {
            modelContext.delete(item)
        }

        do {
            try modelContext.save()
            InAppLogStore.shared.append("Reset \(count) focus item(s) from cache", for: "Cache", type: .cache)
        } catch {
            InAppLogStore.shared.append("Failed to reset focus items: \(error.localizedDescription)", for: "Cache", type: .cache)
        }
    }

}
