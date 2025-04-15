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

    @State private var showClearConfirmation = false

    var body: some View {
        let logs = store.allLogs(for: provider)

        Group {
            if logs.isEmpty {
                VStack {
                    Spacer()
                    Text("No logs yet")
                        .font(.headline)
                        .foregroundColor(.secondary)
                    Spacer()
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                List {
                    Section(header: Text("Logs")) {
                        ForEach(logs) { entry in
                            NavigationLink(destination: LogDetailView(log: entry, provider: provider)) {
                                HStack(alignment: .top, spacing: 8) {
                                    Image(systemName: entry.type.symbolName)
                                        .foregroundColor(entry.type.color)
                                        .frame(width: 20)

                                    VStack(alignment: .leading, spacing: 2) {
                                        Text(entry.message)
                                            .lineLimit(1)
                                            .truncationMode(.tail)

                                        Text(entry.timestamp.formatted(date: .omitted, time: .standard))
                                            .font(.caption)
                                            .foregroundColor(.secondary)
                                    }
                                }
                                .padding(.vertical, 2)
                            }
                        }
                    }
                }
            }
        }
        .navigationTitle(provider)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Menu {
                    Button {
                        logTestEvents()
                    } label: {
                        Label("Log Test Events", systemImage: "plus.square.on.square")
                    }

                    if !logs.isEmpty {
                        Button(role: .destructive) {
                            showClearConfirmation = true
                        } label: {
                            Label("Clear Logs", systemImage: "trash")
                        }
                    }
                } label: {
                    Image(systemName: "ellipsis.circle")
                        .imageScale(.large)
                }
            }
        }
        .confirmationDialog("Are you sure you want to clear all logs?", isPresented: $showClearConfirmation, titleVisibility: .visible) {
            Button("Clear Logs", role: .destructive) {
                store.clear(provider: provider)
            }
            Button("Cancel", role: .cancel) {}
        }
    }

    private func logTestEvents() {
        let longText = """
        This is a long simulated log message that could represent an API request or response.
        {
            "user_id": 123,
            "action": "test_event",
            "params": {
                "device": "iOS",
                "version": "1.0.0",
                "metadata": {
                    "nested": true,
                    "more_data": ["sample", "values", "go", "here"]
                }
            }
        }
        End of log.
        """

        store.append("Simulated event log\n\(longText)", for: provider, type: .event)
        store.append("Simulated screen view\n\(longText)", for: provider, type: .screen)
        store.append("Simulated user identification\n\(longText)", for: provider, type: .user)
        store.append("Simulated startup process\n\(longText)", for: provider, type: .startup)
        store.append("Simulated generic message\n\(longText)", for: provider, type: .generic)
    }
}
