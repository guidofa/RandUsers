//
//  UserRepository.swift
//  RandUsers
//
//  Created by Guido Fabio on 7/3/25.
//

import Foundation

// MARK: - Repositorio de Usuarios

protocol UserRepository {
    func getUsers(page: Int, seed: String?) async throws -> ResultModel
}

struct UserRepositoryImpl: UserRepository {
    private let networkManager: NetworkManager
    private let userLocalRepository: UserLocalRepository

    init(
        networkManager: NetworkManager,
        userLocalRepository: UserLocalRepository
    ) {
        self.networkManager = networkManager
        self.userLocalRepository = userLocalRepository
    }

    func getUsers(page: Int, seed: String?) async throws -> ResultModel {
        if let cachedResult = await userLocalRepository.getUserModel(page: page, seed: seed) {
            return cachedResult
        }

        let url = try buildURL(page: page, seed: seed)

        let (data, response) = try await networkManager.fetchData(from: url)

        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200,
              httpResponse.mimeType == "application/json" else {
            throw URLError(.badServerResponse)
        }

        let jsonResponse = try JSONDecoder().decode(ResultResponse.self, from: data)
        let resultModel = jsonResponse.toResultModel()

        await userLocalRepository.saveUserModel(resultModel)

        return resultModel
    }

    private func buildURL(page: Int, seed: String?) throws -> URL {
        guard var components = URLComponents(string: NetworkConstants.apiBaseURLString) else {
            throw URLError(.badURL)
        }

        var queryItems: [URLQueryItem] = [
            URLQueryItem(name: "page", value: String(page)),
            URLQueryItem(name: "results", value: NetworkConstants.usersPerPage)
        ]

        if let seed = seed {
            queryItems.append(URLQueryItem(name: "seed", value: seed))
        }

        components.queryItems = queryItems

        guard let url = components.url, url.scheme != nil, url.host != nil else {
            throw URLError(.badURL)
        }

        return url
    }
}
