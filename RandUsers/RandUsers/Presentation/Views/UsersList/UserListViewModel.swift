//
//  UserListViewModel.swift
//  RandUsers
//
//  Created by Guido Fabio on 7/3/25.
//

import Foundation

class UserListViewModel: ObservableObject {
    // MARK: - Published vars

    @Published var state = ViewState.loading
    @Published var usersList = [UserModel]()

    // MARK: - Public Enums

    enum TriggerAction {
        case getUsersList
        case loadMore
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
        case .getUsersList:
            await getUsersList()

        case .loadMore:
            await loadMore()
        }
    }

    // MARK: - Private functions

    private func loadMore() async {
        // TODO: implement logic to load more
        print("Load More")
    }

    private func getUsersList() async {
        do {
            await setLoadingState(state: .loading)

            let response = try await getUserListUseCase.execute(page: 1, seed: nil)

            await setUsersList(response)

            await setLoadingState(state: .loaded)
        } catch let error {
            print(error.localizedDescription)
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
}
