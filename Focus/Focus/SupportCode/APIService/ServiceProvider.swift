//
//  ServiceProvider.swift
//  Focus
//
//  Created by Ryan Thomas on 4/19/25.
//


struct ServiceProvider {
    let baseURL: String
    let authToken: String?
}

extension ServiceProvider {
    static let myBackend = ServiceProvider(baseURL: "https://api.myapp.com", authToken: "abc123")
    static let openAI = ServiceProvider(baseURL: "https://api.openai.com/v1", authToken: "Bearer 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")
    static let swapi = ServiceProvider(baseURL: "https://www.swapi.tech/api", authToken: nil)
}
