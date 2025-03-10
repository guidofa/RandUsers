//
//  UserRepository.swift
//  RandUsers
//
//  Created by Guido Fabio on 7/3/25.
//

import Foundation

protocol UserRepository {
    func getUsers(page: Int, seed: String?) async throws -> ResultModel
}

struct UserRepositoryImpl: UserRepository {
    private let session: URLSession
    private let userLocalRepository: UserLocalRepository

    init(
        session: URLSession = .shared,
        userLocalRepository: UserLocalRepository
    ) {
        self.session = session
        self.userLocalRepository = userLocalRepository
    }

    func getUsers(page: Int, seed: String?) async throws -> ResultModel {
        if let cachedResult = await userLocalRepository.getUserModel(page: page, seed: seed) {
            return cachedResult
        }

        do {
            var components = URLComponents(string: NetworkConstants.apiBaseURLString)

            var queryItems: [URLQueryItem] = [
                URLQueryItem(name: "page", value: String(page)),
                URLQueryItem(name: "results", value: NetworkConstants.usersPerPage)
            ]

            if let seed {
                queryItems.append(.init(name: "seed", value: seed))
            }

            components?.queryItems = queryItems

            guard let url = components?.url, url.scheme != nil, url.host != nil else {
                throw URLError(.badURL)
            }

            print("🌐 API call: \(url.absoluteString)")
            let (data, response) = try await session.data(from: url)

            guard let httpResponse = response as? HTTPURLResponse,
                  httpResponse.statusCode == 200,
                  httpResponse.mimeType == "application/json" else {
                throw URLError(.badServerResponse )
            }

            print("✅ Response: \(String(data: data, encoding: .utf8) ?? "❌ Error decoding data")")

            let jsonResponse = try JSONDecoder().decode(ResultResponse.self, from: data)

            let resultModel = jsonResponse.toResultModel()

            await userLocalRepository.saveUserModel(resultModel)

            return resultModel
        } catch let error {
            throw error
        }
    }
}
