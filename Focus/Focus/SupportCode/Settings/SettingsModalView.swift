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

    let contextualOptions: [ContextualSetting]

    var body: some View {
        NavigationView {
            SettingsView(
                auth: auth,
                contextualOptions: contextualOptions
            )
        }
        .presentationDetents([.medium, .large])
        .presentationDragIndicator(.visible)
    }
}
