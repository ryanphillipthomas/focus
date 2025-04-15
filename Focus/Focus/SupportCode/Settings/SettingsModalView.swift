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

    let inlineContextualOptions: [ContextualSetting]
    let groupedContextualOptions: [ContextualSetting]

    var body: some View {
        NavigationView {
            SettingsView(
                auth: auth,
                inlineContextualOptions: inlineContextualOptions,
                groupedContextualOptions: groupedContextualOptions
            )
        }
        .presentationDetents([.medium, .large])
        .presentationDragIndicator(.visible)
    }
}
