//
//  AppReviewListView.swift
//  Focus
//
//  Created by Ryan Thomas on 4/14/25.
//


import SwiftUI
import StoreKit

struct AppReviewListView: View {

    var body: some View {
        List {
            Section {
                Button("Rate This App") {
                    requestReview()
                }
            }
        }
    }
    
    private func requestReview() {
    #if os(iOS)
        if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            AppStore.requestReview(in: scene)
        }
    #elseif os(macOS)
        if let url = URL(string: "macappstore://itunes.apple.com/app/idYOUR_APP_ID?action=write-review") {
            NSWorkspace.shared.open(url)
        }
    #endif
    }
}
