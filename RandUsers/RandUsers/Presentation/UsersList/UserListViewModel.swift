//
//  UserListViewModel.swift
//  RandUsers
//
//  Created by Guido Fabio on 7/3/25.
//

import Foundation

class UserListViewModel: ObservableObject {
    let networkManager: NetworkManager
    var usersList = [UserModel]()

    init(usersList: [UserModel] = [UserModel](), networkManager: NetworkManager) {
        self.networkManager = networkManager
        self.usersList = usersList
    }

    func getUsersList() async {
        do {
            let response = try await networkManager.getUsers()
            print(response)
        } catch let error {
            print(error.localizedDescription)
        }
    }
}
