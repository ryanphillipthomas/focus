//
//  ChartView.swift
//  Focus
//
//  Created by Ryan Thomas on 4/20/25.
//


import SwiftUI
import Charts

struct ChartView: View {
    @ObservedObject var manager: ChartManager

    var body: some View {
        VStack {
            Text("Focus vs. Distraction")
                .font(.title2)
                .bold()
                .padding()

            Chart {
                ForEach(manager.dataPoints) { point in
                    BarMark(
                        x: .value("Day", point.label),
                        y: .value("Minutes", point.value)
                    )
                    .foregroundStyle(by: .value("Type", point.type.rawValue))
                    .position(by: .value("Type", point.type.rawValue)) // 🧼 this is the key fix
                }
            }
            .chartLegend(.visible)
            .chartScrollableAxes(.horizontal)
            .chartXVisibleDomain(length: 4)
            .chartScrollTargetBehavior(.paging)
            .frame(height: 300)
            .padding()
            Text("Weekly Focus Score")
                .font(.title2)
                .bold()
                .padding()
            Chart {
                ForEach(manager.dataPoints) { point in
                    LineMark(
                        x: .value("Day", point.label),
                        y: .value("Value", point.value)
                    )
                    .interpolationMethod(.catmullRom)
                    .symbol(.circle)
                }
            }
            .chartScrollableAxes(.horizontal)
            .chartXVisibleDomain(length: 3)
            .chartScrollTargetBehavior(.paging) // ✅ For string-based labels

        }
    }
}
