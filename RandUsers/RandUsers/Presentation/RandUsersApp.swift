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
    private let networkManager: NetworkManager

    init() {
        self.networkManager = NetworkManagerImpl()
        self.getUserListUseCase = GetUserListUseCase(networkManager: networkManager)
    }

    var body: some Scene {
        WindowGroup {
            UserListView(
                viewModel: UserListViewModel(networkManager: networkManager)
            )
        }
    }
}
