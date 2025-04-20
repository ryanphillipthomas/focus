//
//  MailItem.swift
//  Focus
//
//  Created by Ryan Thomas on 4/19/25.
//


//
//  MailItem.swift
//  Focus
//
//  Created by Ryan Thomas on 4/19/25.
//

import Foundation

struct MailItem: Identifiable, Codable, Hashable {
    let id: String                  // Gmail message ID
    var threadID: String?
    var subject: String?
    var snippet: String?
    var sender: String?
    var recipient: String?
    var timestamp: Date?
    var isRead: Bool = false
    var labels: [String] = []

    // Optional: human-readable formatting
    var formattedDate: String {
        guard let timestamp = timestamp else { return "" }
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: timestamp)
    }
}
