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
    private let baseURL = "https://www.swapi.tech/api"

    private init() {
        let interceptor = AuthInterceptor()

        let eventMonitor = APILogger()
        self.session = Session(interceptor: interceptor, eventMonitors: [eventMonitor])
    }

    func get<T: Decodable>(_ path: String, responseType: T.Type) async throws -> T {
        let url = "\(baseURL)/\(path)"
        let request = session.request(url).validate()
        let data = try await request.serializingData().value

        // Log raw JSON
        let rawJSON = LogFormatter.prettyPrintJSON(from: data)
        let truncated = LogFormatter.truncate(LogFormatter.redactKeys(in: rawJSON))
        APILogger.log("Raw JSON from \(url):\n\(truncated)")

        // Decode and optionally log the model
        let decoded = try JSONDecoder().decode(T.self, from: data)
        APILogger.log("Decoded \(T.self) from \(url): \(String(describing: decoded))")
        return decoded
    }


    func post<T: Decodable>(_ path: String, parameters: Parameters, responseType: T.Type) async throws -> T {
        let url = "\(baseURL)/\(path)"
        return try await session.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default)
            .validate()
            .serializingDecodable(T.self)
            .value
    }
}

// MARK: - AuthInterceptor

class AuthInterceptor: RequestInterceptor, @unchecked Sendable {
    var token: String {
        return "Bearer YOUR_TOKEN_HERE" // Replace with secure token storage
    }

    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        var request = urlRequest
        request.setValue(token, forHTTPHeaderField: "Authorization")
        completion(.success(request))
    }
}
