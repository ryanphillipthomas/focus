//
//  GmailParser.swift
//  Focus
//
//  Created by Ryan Thomas on 4/19/25.
//


//
//  GmailParser.swift
//  Focus
//
//  Created by Ryan Thomas on 4/19/25.
//

import Foundation

struct GmailParser {
    static func parseMessage(from json: [String: Any]) -> MailItem? {
        guard let id = json["id"] as? String else { return nil }

        let threadID = json["threadId"] as? String
        let snippet = json["snippet"] as? String
        let labelIds = json["labelIds"] as? [String] ?? []

        var subject: String?
        var from: String?
        var to: String?
        var date: Date?

        if let payload = json["payload"] as? [String: Any],
           let headers = payload["headers"] as? [[String: Any]] {

            for header in headers {
                guard let name = header["name"] as? String,
                      let value = header["value"] as? String else { continue }

                switch name.lowercased() {
                case "subject": subject = value
                case "from": from = value
                case "to": to = value
                case "date": date = parseDate(value)
                default: break
                }
            }
        }

        return MailItem(
            id: id,
            threadID: threadID,
            subject: subject,
            snippet: snippet,
            sender: from,
            recipient: to,
            timestamp: date,
            isRead: !labelIds.contains("UNREAD"),
            labels: labelIds
        )
    }

    private static func parseDate(_ dateString: String) -> Date? {
        // Gmail sends dates like "Fri, 19 Apr 2025 15:24:00 -0400"
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "EEE, dd MMM yyyy HH:mm:ss Z"
        return formatter.date(from: dateString)
    }
}
