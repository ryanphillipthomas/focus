//
//  GmailViewModel.swift
//  Focus
//
//  Created by Ryan Thomas on 4/19/25.
//

import SwiftUI

class GmailViewModel: ObservableObject {
    func fetchAndLogInbox(accessToken: String) {
        let url = URL(string: "https://gmail.googleapis.com/gmail/v1/users/me/messages")!
        var request = URLRequest(url: url)
        request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")

        URLSession.shared.dataTask(with: request) { data, _, error in
            guard let data = data else {
                InAppLogStore.shared.append("Failed to fetch Gmail messages: \(error?.localizedDescription ?? "No data")", for: "Gmail", type: .gmail)
                return
            }
            do {
                let jsonObject = try JSONSerialization.jsonObject(with: data, options: [])
                let prettyData = try JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted)
                if let prettyString = String(data: prettyData, encoding: .utf8) {
                    InAppLogStore.shared.append("Gmail Inbox Response:\n\(prettyString)", for: "Gmail", type: .gmail)
                }

                if let json = jsonObject as? [String: Any],
                   let messages = json["messages"] as? [[String: Any]] {
                    for message in messages.prefix(10) {
                        if let id = message["id"] as? String {
                            self.fetchAndLogMessageDetail(id: id, accessToken: accessToken)
                        }
                    }
                }

            } catch {
                InAppLogStore.shared.append("Failed to parse Gmail inbox data: \(error.localizedDescription)", for: "Gmail", type: .gmail)
            }
        }.resume()
    }


    private func fetchAndLogMessageDetail(id: String, accessToken: String) {
        let url = URL(string: "https://gmail.googleapis.com/gmail/v1/users/me/messages/\(id)?format=metadata")!
        var request = URLRequest(url: url)
        request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")

        URLSession.shared.dataTask(with: request) { data, _, error in
            guard let data = data else {
                InAppLogStore.shared.append("Failed to fetch Gmail message \(id): \(error?.localizedDescription ?? "No data")", for: "Gmail", type: .gmail)
                return
            }
            
            if let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
               let mailItem = GmailParser.parseMessage(from: json) {
                InAppLogStore.shared.append("\(mailItem.subject ?? "No Subject")", for: "Gmail", type: .gmail)
            }

        }.resume()
    }
}
