//
//  DeleteUserUseCase.swift
//  RandUsers
//
//  Created by Guido Fabio on 9/3/25.
//

import Foundation

protocol DeleteUserUseCase {
    func execute(userModel: UserModel) async -> UserModel?
}

struct DeleteUserUseCaseImpl: DeleteUserUseCase {
    private let userLocalRepository: UserLocalRepository

    init(userLocalRepository: UserLocalRepository) {
        self.userLocalRepository = userLocalRepository
    }

    func execute(userModel: UserModel) async -> UserModel? {
        await userLocalRepository.deleteUser(userModel: userModel)
    }
}
