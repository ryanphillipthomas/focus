//
//  WithSettingsOverlay.swift
//  Focus
//
//  Created by Ryan Thomas on 4/11/25.
//
import SwiftUI

struct WithSettingsOverlay<Content: View>: View {
    @State private var showSettings = false
    @EnvironmentObject var model: ThemeModel
    @State var auth = AuthViewModel() // Or inject if you already have one

    let content: Content

    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    var body: some View {
        ZStack {
            content
            SettingsButtonView(showSettings: $showSettings)
        }
        .sheet(isPresented: $showSettings) {
            SettingsModalView(auth: auth)
                .environmentObject(model)
        }
    }
}
