//
//  TipKitManager.swift
//  Focus
//
//  Created by Ryan Thomas on 4/20/25.
//


import TipKit

@MainActor
final class TipKitManager: ObservableObject {
    static let shared = TipKitManager()

    func configure() {
        do {
            try Tips.configure([
                .displayFrequency(.immediate), // No need for `TipOption.` prefix
            ])
        } catch {
            print("⚠️ TipKit configuration failed: \(error)")
        }
    }

    func reset() {
        do {
            try Tips.resetDatastore()
        } catch {
            print("⚠️ Failed to reset TipKit datastore: \(error)")
        }
    }

    func invalidate(_ tip: some Tip) {
        tip.invalidate(reason: .tipClosed)
    }
}
