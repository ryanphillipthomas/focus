//
//  ChartManager.swift
//  Focus
//
//  Created by Ryan Thomas on 4/20/25.
//


import Foundation

enum FocusType: String, CaseIterable {
    case focus = "Focus Time"
    case distraction = "Distraction Time"
}

struct ChartDataPoint: Identifiable {
    let id = UUID()
    let label: String // e.g., "Mon"
    let type: FocusType
    let value: Double
}

class ChartManager: ObservableObject {
    @Published var dataPoints: [ChartDataPoint] = []

    init() {
        loadMockData()
    }

    func loadMockData() {
        let labels = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]
        self.dataPoints = labels.flatMap { day in
            [
                ChartDataPoint(label: day, type: .focus, value: Double.random(in: 4...8)),
                ChartDataPoint(label: day, type: .distraction, value: Double.random(in: 1...4))
            ]
        }
    }
}
