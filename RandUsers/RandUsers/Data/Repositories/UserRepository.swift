//
//  UserRepository.swift
//  RandUsers
//
//  Created by Guido Fabio on 7/3/25.
//

import Foundation

protocol UserRepository {
    func getUsers() async throws -> [UserModel]
}

struct UserRepositoryImpl: UserRepository {
    private let urlString = "https://api.randomuser.me/?results=5"
    private let session: URLSession

    init(
        session: URLSession = .shared
    ) {
        self.session = session
    }

    func getUsers() async throws -> [UserModel] {
        do {
            guard let url = URL(string: urlString), url.scheme != nil, url.host != nil else {
                throw URLError(.badURL)
            }

            let (data, response) = try await session.data(from: url)

            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                throw URLError(.badServerResponse )
            }

            let userListResponse = try JSONDecoder().decode(UserListResponse.self, from: data)

            return userListResponse.results.map { .init(gender: $0.gender) }
        } catch let error {
            throw error
        }
    }
}
