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
        return try await session.data(from: url)
    }
}
