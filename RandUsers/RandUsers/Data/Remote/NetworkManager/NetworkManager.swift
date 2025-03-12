//
//  NetworkManager.swift
//  RandUsers
//
//  Created by Guido Fabio on 11/3/25.
//

import Foundation

protocol NetworkManager {
    func fetchData(from url: URL) async throws -> (Data, URLResponse)
}

struct NetworkManagerImpl: NetworkManager {
    private let session: URLSession

    init(session: URLSession = .shared) {
        self.session = session
    }

    func fetchData(from url: URL) async throws -> (Data, URLResponse) {
        print("🔍 Fetching data from: \(url)")

        let response = try await session.data(from: url)

        if let httpResponse = response.1 as? HTTPURLResponse {
            if httpResponse.statusCode == 200 {
                print("✅ \(httpResponse.statusCode) Response: \(String(decoding: response.0, as: Unicode.UTF8.self))")
            } else {
                print("❌ Error: \(httpResponse.statusCode)")
            }
        }

        return try await session.data(from: url)
    }
}
