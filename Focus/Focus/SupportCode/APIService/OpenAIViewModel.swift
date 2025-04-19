//
//  OpenAIViewModel.swift
//  Focus
//
//  Created by Ryan Thomas on 4/19/25.
//


import Foundation
import SwiftUI

import Foundation

struct ChatMessage: Identifiable {
    let id = UUID()
    let role: String // "user" or "assistant"
    let content: String
}

@MainActor
class OpenAIViewModel: ObservableObject {
    @Published var inputText: String = ""
    @Published var messages: [ChatMessage] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?

    func send() async {
        let trimmed = inputText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }

        let userMessage = ChatMessage(role: "user", content: trimmed)
        messages.append(userMessage)
        inputText = ""
        isLoading = true
        errorMessage = nil

        do {
            let formattedMessages = messages.map { ["role": $0.role, "content": $0.content] }
            let response = try await APIManager.shared.sendChat(messages: formattedMessages)
            let reply = ChatMessage(role: "assistant", content: response)
            messages.append(reply)
        } catch {
            errorMessage = error.localizedDescription
        }

        isLoading = false
    }
}
