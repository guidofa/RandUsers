//
//  UserRepository.swift
//  RandUsers
//
//  Created by Guido Fabio on 7/3/25.
//

import Foundation

protocol HTTPClient {
    func fetchData(from url: URL) async throws -> (Data, URLResponse)
}

struct URLSessionHTTPClient: HTTPClient {
    private let session: URLSession

    init(session: URLSession = .shared) {
        self.session = session
    }

    func fetchData(from url: URL) async throws -> (Data, URLResponse) {
        return try await session.data(from: url)
    }
}

// MARK: - Repositorio de Usuarios

/// Protocolo para el repositorio de usuarios.
protocol UserRepository {
    func getUsers(page: Int, seed: String?) async throws -> ResultModel
}

/// Implementación del repositorio de usuarios.
struct UserRepositoryImpl: UserRepository {
    private let httpClient: HTTPClient
    private let userLocalRepository: UserLocalRepository

    init(
        httpClient: HTTPClient = URLSessionHTTPClient(),
        userLocalRepository: UserLocalRepository
    ) {
        self.httpClient = httpClient
        self.userLocalRepository = userLocalRepository
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

    func getUsers(page: Int, seed: String?) async throws -> ResultModel {
        if let cachedResult = await userLocalRepository.getUserModel(page: page, seed: seed) {
            return cachedResult
        }

        let url = try buildURL(page: page, seed: seed)

        let (data, response) = try await httpClient.fetchData(from: url)

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
}
