//
//  LogFormatter.swift
//  Focus
//
//  Created by Ryan Thomas on 4/19/25.
//


import Foundation

enum LogFormatter {
    static func prettyPrintJSON(from data: Data) -> String {
        if let jsonObject = try? JSONSerialization.jsonObject(with: data, options: []),
           let formatted = try? JSONSerialization.data(withJSONObject: jsonObject, options: [.prettyPrinted]),
           let string = String(data: formatted, encoding: .utf8) {
            return string
        }

        return String(data: data, encoding: .utf8) ?? "<unreadable>"
    }

    static func truncate(_ string: String, limit: Int = 1000) -> String {
        string.count > limit ? String(string.prefix(limit)) + "…" : string
    }

    static func redactKeys(in json: String, keys: [String] = ["token", "password"]) -> String {
        var redacted = json
        for key in keys {
            redacted = redacted.replacingOccurrences(of: "\"\(key)\": \"[^\"]*\"", with: "\"\(key)\": \"••••\"", options: .regularExpression)
        }
        return redacted
    }
}
