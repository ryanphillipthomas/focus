//  APIManager.swift
//  Focus
//
//  Created by Ryan Thomas on 4/18/25.

import Foundation
import Alamofire

// MARK: - APIManager

class APIManager {
    static let shared = APIManager()
    
    private let session: Session

    private init() {
        let eventMonitor = APILogger()
        self.session = Session(eventMonitors: [eventMonitor])
    }

    func get<T: Decodable>(_ path: String, responseType: T.Type, provider: ServiceProvider) async throws -> T {
        let url = "\(provider.baseURL)/\(path)"
        var headers: HTTPHeaders = []

        if let token = provider.authToken {
            headers.add(name: "Authorization", value: token)
        }

        let request = session.request(url, headers: headers).validate()
        let data = try await request.serializingData().value
        return try JSONDecoder().decode(T.self, from: data)
    }
    
    func post<T: Decodable, U: Encodable>(_ path: String, body: U, responseType: T.Type, provider: ServiceProvider) async throws -> T {
        let url = "\(provider.baseURL)/\(path)"
        var headers: HTTPHeaders = [
            .contentType("application/json")
        ]

        if let token = provider.authToken {
            headers.add(name: "Authorization", value: token)
        }

        let request = session.request(
            url,
            method: .post,
            parameters: body,
            encoder: JSONParameterEncoder.default,
            headers: headers
        ).validate()

        let data = try await request.serializingData().value
        return try JSONDecoder().decode(T.self, from: data)
    }
}


// MARK: - OpenAI Chat Extension
extension APIManager {
    func sendChat(
        messages: [[String: String]],
        model: String = "gpt-4"
    ) async throws -> String {
        struct ChatRequest: Encodable {
            let model: String
            let messages: [[String: String]]
        }

        let body = ChatRequest(model: model, messages: messages)

        let response = try await post(
            "chat/completions",
            body: body,
            responseType: OpenAIResponse.self,
            provider: .openAI
        )

        return response.choices.first?.message.content ?? "No response"
    }
}
