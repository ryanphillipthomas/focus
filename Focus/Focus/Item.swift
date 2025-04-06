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
    var secondsRemaining: Int

    init(timestamp: Date) {
        self.id = UUID()
        self.timestamp = timestamp
        self.isTimerRunning = false
        self.secondsRemaining = 120
    }
}
