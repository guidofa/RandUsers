//
//  UserListViewModel.swift
//  RandUsers
//
//  Created by Guido Fabio on 7/3/25.
//

import Foundation

class UserListViewModel: ObservableObject {
    let getUserListUseCase: GetUserListUseCase
    var usersList = [UserModel]()

    init(getUserListUseCase: GetUserListUseCase, usersList: [UserModel] = [UserModel]()) {
        self.getUserListUseCase = getUserListUseCase
        self.usersList = usersList
    }

    func getUsersList() async {
        do {
            let response = try await getUserListUseCase.execute()
            print(response)
        } catch let error {
            print(error.localizedDescription)
        }
    }
}
