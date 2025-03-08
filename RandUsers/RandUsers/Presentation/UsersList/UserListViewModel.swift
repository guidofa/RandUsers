//
//  UserListViewModel.swift
//  RandUsers
//
//  Created by Guido Fabio on 7/3/25.
//

import Foundation

class UserListViewModel: ObservableObject {
    enum ViewState {
        case loading
        case loaded
        case error
    }

    private let getUserListUseCase: GetUserListUseCase

    init(getUserListUseCase: GetUserListUseCase, usersList: [UserModel] = [UserModel]()) {
        self.getUserListUseCase = getUserListUseCase
        self.usersList = usersList
    }

    func trigger(_ action: TriggerAction) async {
        switch action {
        case .getUsersList:
            await getUsersList()
        }
    }

    private func getUsersList() async {
        do {
            await setLoadingState(state: .loading)

            let response = try await getUserListUseCase.execute()

            await setUsersList(response)

            await setLoadingState(state: .loaded)
        } catch let error {
            await setLoadingState(state: .error)
        }
    }

    // MARK: - MainActor methods

    @MainActor
    func setUsersList(_ usersList: [UserModel]) {
        self.usersList = usersList
    }

    @MainActor
    func setLoadingState(state: ViewState) {
        self.state = state
    }

    // MARK: - Published vars

    @Published var state = ViewState.loading
    @Published var usersList = [UserModel]()

    // MARK: - Triggers

    enum TriggerAction{
        case getUsersList
    }
}
