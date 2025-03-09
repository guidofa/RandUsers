//
//  SearchUserUseCase.swift
//  RandUsers
//
//  Created by Guido Fabio on 9/3/25.
//

import Foundation

protocol SearchUserUseCase {
    func execute(searchTerm: String) async -> [UserModel]
}

struct SearchUserUseCaseImpl: SearchUserUseCase {
    private let userLocalRepository: UserLocalRepository

    init(userLocalRepository: UserLocalRepository) {
        self.userLocalRepository = userLocalRepository
    }

    func execute(searchTerm: String) async -> [UserModel] {
        return await userLocalRepository.searchUsers(searchTerm: searchTerm)
    }
}
