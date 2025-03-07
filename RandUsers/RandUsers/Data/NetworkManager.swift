//
//  NetworkManager.swift
//  RandUsers
//
//  Created by Guido Fabio on 7/3/25.
//

import Foundation

protocol NetworkManager {
    func getUsers() async throws -> [UserResponse]
}

struct NetworkManagerImpl: NetworkManager {
    private var session: URLSession
    private var baseURL: String

    init(
        session: URLSession = .shared,
        baseURL: String = "https://api.randomuser.me/?results=5"
    ) {
        self.session = session
        self.baseURL = baseURL
    }

    func getUsers() async throws -> [UserResponse] {
        let urlString = baseURL

        do {
            guard let url = URL(string: urlString), url.scheme != nil, url.host != nil else {
                throw URLError(.badURL)
            }

            let (data, response) = try await session.data(from: url)

            guard let httpResponse = response as? HTTPURLResponse else {
                throw URLError(.badServerResponse )
            }

            guard httpResponse.statusCode == 200 else {
                throw URLError(.badServerResponse)
            }

            let userListResponse = try JSONDecoder().decode(UserListResponse.self, from: data)

            return userListResponse.results
        } catch let error {
            throw error
        }
    }
}
