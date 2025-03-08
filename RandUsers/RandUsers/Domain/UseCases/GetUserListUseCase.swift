//
//  Untitled.swift
//  RandUsers
//
//  Created by Guido Fabio on 7/3/25.
//

import Foundation

protocol GetUserListUseCase {
    func execute(page: Int, seed: String?) async throws -> [UserModel]
}

struct GetUserListUseCaseImpl: GetUserListUseCase {
    private let userRepository: UserRepository

    init(userRepository: UserRepository) {
        self.userRepository = userRepository
    }

    func execute(page: Int, seed: String?) async throws -> [UserModel] {
        return try await userRepository.getUsers(page: page, seed: seed)
    }
}
