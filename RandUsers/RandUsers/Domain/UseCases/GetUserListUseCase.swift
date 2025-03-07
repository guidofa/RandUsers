//
//  Untitled.swift
//  RandUsers
//
//  Created by Guido Fabio on 7/3/25.
//

import Foundation

protocol GetUserListUseCase {
    func execute() async throws -> [UserModel]
}

struct GetUserListUseCaseImpl: GetUserListUseCase {
    private let userRepository: UserRepository

    init(userRepository: UserRepository) {
        self.userRepository = userRepository
    }

    func execute() async throws -> [UserModel] {
        return try await userRepository.getUsers()
    }
}
