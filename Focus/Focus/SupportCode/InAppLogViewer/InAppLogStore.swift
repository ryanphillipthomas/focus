//
//  InAppLogStore.swift
//  Focus
//
//  Created by Ryan Thomas on 4/14/25.
//


import Foundation

class InAppLogStore: ObservableObject {
    static let shared = InAppLogStore()
    
    @Published private(set) var logs: [String: [String]] = [:]

    private init() {}

    func append(_ message: String, for provider: String) {
        DispatchQueue.main.async {
            var entries = self.logs[provider] ?? []
            entries.append(message)
            self.logs[provider] = entries
        }
    }

    func clear(provider: String) {
        DispatchQueue.main.async {
            self.logs[provider] = []
        }
    }

    func allLogs(for provider: String) -> [String] {
        logs[provider] ?? []
    }
}
