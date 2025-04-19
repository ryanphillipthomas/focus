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
    static let openAI = ServiceProvider(baseURL: "https://api.openai.com/v1", authToken: Secrets.openAIKey)
    static let swapi = ServiceProvider(baseURL: "https://www.swapi.tech/api", authToken: nil)
}
