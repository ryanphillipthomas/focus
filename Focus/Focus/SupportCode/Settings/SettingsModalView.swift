//
//  SettingsModalView.swift
//  Focus
//
//  Created by Ryan Thomas on 4/11/25.
//
import SwiftUI

struct SettingsModalView: View {
    @EnvironmentObject var model: ThemeModel
    @Bindable var auth: AuthViewModel

    let contextualAdvancedOptions: [ContextualSetting]

    var body: some View {
        NavigationView {
            SettingsView(auth: auth, contextualAdvancedOptions: contextualAdvancedOptions)
        }
        .presentationDetents([.medium, .large])
        .presentationDragIndicator(.visible)
    }
}
