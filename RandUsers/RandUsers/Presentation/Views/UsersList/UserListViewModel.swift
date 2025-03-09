//
//  UserListViewModel.swift
//  RandUsers
//
//  Created by Guido Fabio on 7/3/25.
//

import Foundation

class UserListViewModel: ObservableObject {
    // MARK: - Published vars

    @Published var state = ViewState.loaded
    @Published var usersList = [UserModel]()

    // MARK: - Private vars

    private var currentPage = 0

    // MARK: - Public Enums

    enum TriggerAction {
        case getUsersList(Int)
    }

    enum ViewState {
        case loading
        case loaded
        case error
    }

    // MARK: - UseCases

    private let getUserListUseCase: GetUserListUseCase

    // MARK: - Init

    init(getUserListUseCase: GetUserListUseCase, usersList: [UserModel] = [UserModel]()) {
        self.getUserListUseCase = getUserListUseCase
        self.usersList = usersList
    }

    // MARK: - Public Functions

    func trigger(_ action: TriggerAction) async {
        switch action {
        case .getUsersList(let page):
            await getUsersList(page: page)
        }
    }

    // MARK: - Private functions

    private func getUsersList(page: Int) async {
        do {
            await setLoadingState(state: .loading)
            self.currentPage += 1
            let response = try await getUserListUseCase.execute(page: currentPage, seed: nil)

            await setUsersList(response)

            await setLoadingState(state: .loaded)
        } catch let error {
            print(error.localizedDescription)
            await setLoadingState(state: .error)
        }
    }

    // MARK: - MainActor methods

    @MainActor
    private func setUsersList(_ usersList: [UserModel]) {
        self.usersList += usersList
    }

    @MainActor
    private func setLoadingState(state: ViewState) {
        self.state = state
    }
}
