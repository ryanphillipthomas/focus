//
//  WithSettingsOverlay.swift
//  Focus
//
//  Created by Ryan Thomas on 4/11/25.

import SwiftUI

struct WithSettingsOverlay<Content: View>: View {
    @State private var showSettings = false
    @EnvironmentObject var model: ThemeModel
    @State var auth = AuthViewModel()

    let content: Content
    let contextualOptions: [ContextualSetting]

    init(
        contextualOptions: [ContextualSetting] = [],
        @ViewBuilder content: () -> Content
    ) {
        self.content = content()
        self.contextualOptions = contextualOptions
    }

    var body: some View {
        ZStack {
            content
            SettingsButtonView(showSettings: $showSettings)
        }
        .sheet(isPresented: $showSettings) {
            SettingsModalView(
                auth: auth,
                contextualOptions: contextualOptions,
            )
            .environmentObject(model)
        }
    }
}
