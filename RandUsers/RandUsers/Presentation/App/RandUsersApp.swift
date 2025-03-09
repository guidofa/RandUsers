//
//  RandUsersApp.swift
//  RandUsers
//
//  Created by Guido Fabio on 6/3/25.
//

import SwiftUI

@main
struct RandUsersApp: App {

    // MARK: - Composition Root

    private let getUserListUseCase: GetUserListUseCase
    private let userRepository: UserRepository
    private let userLocalRepository: UserLocalRepository

    init() {
        self.userLocalRepository = UserLocalRepositoryImpl()
        self.userRepository = UserRepositoryImpl(
            userLocalRepository: userLocalRepository
        )
        self.getUserListUseCase = GetUserListUseCaseImpl(
            userRepository: userRepository
        )
    }

    var body: some Scene {
        WindowGroup {
            UserListView(
                viewModel: UserListViewModel(getUserListUseCase: getUserListUseCase)
            )
        }
    }
}
