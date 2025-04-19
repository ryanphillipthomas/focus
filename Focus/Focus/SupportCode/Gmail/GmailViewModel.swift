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
            guard let data = data,
                  let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
                  let messages = json["messages"] as? [[String: Any]] else {
                InAppLogStore.shared.append("❌ Failed to fetch Gmail messages: \(error?.localizedDescription ?? "Unknown error")", for: "Gmail")
                return
            }

            for message in messages.prefix(10) { // limit for now
                if let id = message["id"] as? String {
                    self.fetchAndLogMessageDetail(id: id, accessToken: accessToken)
                }
            }
        }.resume()
    }

    private func fetchAndLogMessageDetail(id: String, accessToken: String) {
        let url = URL(string: "https://gmail.googleapis.com/gmail/v1/users/me/messages/\(id)?format=metadata")!
        var request = URLRequest(url: url)
        request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")

        URLSession.shared.dataTask(with: request) { data, _, error in
            guard let data = data else {
                InAppLogStore.shared.append("❌ Failed to fetch Gmail message \(id): \(error?.localizedDescription ?? "No data")", for: "Gmail")
                return
            }

            if let raw = String(data: data, encoding: .utf8) {
                InAppLogStore.shared.append("📩 Gmail Message [\(id)]: \(raw)", for: "Gmail")
            }
        }.resume()
    }
}
