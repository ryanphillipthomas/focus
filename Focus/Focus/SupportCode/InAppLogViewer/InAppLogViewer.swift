//
//  InAppLogViewer.swift
//  Focus
//
//  Created by Ryan Thomas on 4/14/25.
//


import SwiftUI

struct InAppLogViewer: View {
    @StateObject private var store = InAppLogStore.shared
    let provider: String

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("\(provider) Logs")
                    .font(.headline)
                Spacer()
                Button("Clear") {
                    store.clear(provider: provider)
                }
            }
            .padding(.bottom, 4)

            ScrollView {
                LazyVStack(alignment: .leading, spacing: 4) {
                    ForEach(store.allLogs(for: provider), id: \.self) { log in
                        logText(for: log)
                            .font(.system(.caption, design: .monospaced))
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
            }
        }
        .padding()
        .navigationTitle(provider)
    }

    // MARK: - Color Coating Logic

    @ViewBuilder
    private func logText(for log: String) -> some View {
        if log.contains("📺") {
            Text(log).foregroundColor(.blue) // screen views
        } else if log.contains("📊") {
            Text(log).foregroundColor(.green) // events
        } else if log.contains("👤") {
            Text(log).foregroundColor(.orange) // user IDs
        } else {
            Text(log).foregroundColor(.gray) // fallback
        }
    }
}
