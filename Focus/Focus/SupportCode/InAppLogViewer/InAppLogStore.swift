//
//  InAppLogStore.swift
//  Focus
//
//  Created by Ryan Thomas on 4/14/25.
//


import Foundation
import Combine

final class InAppLogStore: ObservableObject {
    static let shared = InAppLogStore()

    @Published private(set) var logsByProvider: [String: [LogEntry]] = [:]

    private let queue = DispatchQueue(label: "InAppLogStoreQueue", qos: .utility)

    private init() {}

    // MARK: - Public API

    func append(_ message: String, for provider: String, type: LogType = .generic) {
        let entry = LogEntry(message: message, timestamp: Date(), type: type)
        queue.async {
            var logs = self.logsByProvider[provider] ?? []
            logs.append(entry)
            DispatchQueue.main.async {
                self.logsByProvider[provider] = logs
            }
        }
    }

    func clear(provider: String) {
        DispatchQueue.main.async {
            self.logsByProvider[provider] = []
        }
    }

    func allLogs(for provider: String) -> [LogEntry] {
        logsByProvider[provider] ?? []
    }
}

