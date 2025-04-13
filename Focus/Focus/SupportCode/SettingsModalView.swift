//
//  SettingsModalView.swift
//  Focus
//
//  Created by Ryan Thomas on 4/11/25.
//
import SwiftUI

struct SettingsModalView: View {
    @EnvironmentObject var model: Model
    @Bindable var auth: AuthViewModel

    var body: some View {
        NavigationView {
            SettingsView(auth: auth)
        }
        .presentationDetents([.medium, .large])
        .presentationDragIndicator(.visible)
    }
}
