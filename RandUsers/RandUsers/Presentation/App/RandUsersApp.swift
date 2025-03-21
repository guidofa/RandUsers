//
//  RandUsersApp.swift
//  RandUsers
//
//  Created by Guido Fabio on 6/3/25.
//

import SwiftUI

@main
struct RandUsersApp: App {
    // MARK: - Managers
    private let networkManager: NetworkManager

    // MARK: - UseCases

    private let deleteUserUseCase: DeleteUserUseCase
    private let getUserListUseCase: GetUserListUseCase
    private let searchUserUseCase: SearchUserUseCase

    // MARK: - Repositories

    private let userLocalRepository: UserLocalRepository
    private let userRepository: UserRepository

    init() {
        self.networkManager = NetworkManagerImpl()
        self.userLocalRepository = UserLocalRepositoryImpl()
        self.userRepository = UserRepositoryImpl(
            networkManager: networkManager,
            userLocalRepository: userLocalRepository
        )
        self.deleteUserUseCase = DeleteUserUseCaseImpl(
            userLocalRepository: userLocalRepository
        )
        self.getUserListUseCase = GetUserListUseCaseImpl(
            userRepository: userRepository
        )
        self.searchUserUseCase = SearchUserUseCaseImpl(
            userLocalRepository: userLocalRepository
        )
    }

    var body: some Scene {
        WindowGroup {
            UserListView(
                viewModel: UserListViewModel(
                    deleteUserUseCase: deleteUserUseCase,
                    getUserListUseCase: getUserListUseCase,
                    searchUserUseCase: searchUserUseCase
                )
            )
        }
    }
}
