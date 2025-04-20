//
//  OpenAIResponse.swift
//  Focus
//
//  Created by Ryan Thomas on 4/19/25.
//


struct OpenAIResponse: Codable {
    let choices: [Choice]

    struct Choice: Codable {
        let message: Message

        struct Message: Codable {
            let role: String
            let content: String
        }
    }
}
