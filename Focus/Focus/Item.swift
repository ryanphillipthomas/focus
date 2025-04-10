//
//  Item.swift
//  Focus
//
//  Created by Ryan Thomas on 4/5/25.
//

import Foundation
import SwiftData

@Model
final class Item {
    var id: UUID
    var timestamp: Date
    var isTimerRunning: Bool
    var duration: Int            // e.g., 120 seconds
    var startDate: Date?         // when timer started

    init(timestamp: Date) {
        self.id = UUID()
        self.timestamp = timestamp
        self.isTimerRunning = false
        self.duration = 120
        self.startDate = nil
    }

    var secondsRemaining: Int {
        guard isTimerRunning, let start = startDate else {
            return duration
        }

        let elapsed = Int(Date().timeIntervalSince(start))
        return max(duration - elapsed, 0)
    }
}
