//
//  GetUserListUseCase.swift
//  RandUsers
//
//  Created by Guido Fabio on 7/3/25.
//

import Foundation

protocol GetUserListUseCase {
    func execute(page: Int, seed: String?) async throws -> ResultModel
}

struct GetUserListUseCaseImpl: GetUserListUseCase {
    private let userRepository: UserRepository

    init(userRepository: UserRepository) {
        self.userRepository = userRepository
    }

    func execute(page: Int, seed: String?) async throws -> ResultModel {
        let result = try await userRepository.getUsers(page: page, seed: seed)
        
        if result.users.filter({ !$0.isDeleted }).count  == .zero {
            return try await execute(page: page + 1, seed: seed)
        }

        return result
    }
}
