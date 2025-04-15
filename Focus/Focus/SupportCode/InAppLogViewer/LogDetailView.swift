//
//  LogDetailView.swift
//  Focus
//
//  Created by Ryan Thomas on 4/14/25.
//

import SwiftUI

struct LogDetailView: View {
    let log: LogEntry
    let provider: String

    @State private var isSharing = false

    private var formattedContent: AttributedString {
        var output = AttributedString()

        // Provider
        var providerText = AttributedString("Provider: \(provider)\n")
        providerText.font = .caption
        providerText.foregroundColor = .secondary
        output.append(providerText)

        // Timestamp
        let timestampStr = log.timestamp.formatted(date: .long, time: .standard)
        var timestampText = AttributedString("Timestamp: \(timestampStr)\n\n")
        timestampText.font = .caption
        timestampText.foregroundColor = .secondary
        output.append(timestampText)

        // Main content
        if let prettyJSON = log.message.prettyPrintedJSON {
            output.append(AttributedString(prettyJSON))
        } else if let markdown = try? AttributedString(markdown: log.message) {
            output.append(markdown)
        } else {
            output.append(AttributedString(log.message))
        }

        return output
    }

    private var shareContent: String {
        let timestampStr = log.timestamp.formatted(date: .long, time: .standard)
        let header = "Provider: \(provider)\nTimestamp: \(timestampStr)\n\n"

        let messageBody: String = {
            if let prettyJSON = log.message.prettyPrintedJSON {
                return prettyJSON
            } else {
                return log.message
            }
        }()

        return header + messageBody
    }

    var body: some View {
        List {
            Section(header: Text("Details")) {
                Text(formattedContent)
                    .textSelection(.enabled)
                    .font(.system(.body, design: .monospaced))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.vertical, 8)
            }
        }
        .navigationTitle("Log Detail")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    isSharing = true
                } label: {
                    Image(systemName: "square.and.arrow.up")
                }
            }
        }
        .sheet(isPresented: $isSharing) {
            ShareSheet(items: [shareContent])
        }
    }
}

extension String {
    var prettyPrintedJSON: String? {
        guard let data = self.data(using: .utf8) else { return nil }
        do {
            let object = try JSONSerialization.jsonObject(with: data, options: [])
            let prettyData = try JSONSerialization.data(withJSONObject: object, options: [.prettyPrinted])
            return String(data: prettyData, encoding: .utf8)
        } catch {
            return nil
        }
    }
}


