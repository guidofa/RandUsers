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

    private var currentResult: ResultModel?

    // MARK: - Public Enums

    enum TriggerAction {
        case filter(searchTerm: String)
        case getUsersList
    }

    enum ViewState {
        case error
        case loaded
        case loading
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
        case .filter(let searchTerm):
            print("Filter triggered with \(searchTerm)")

        case .getUsersList:
            await getUsersList()
        }
    }

    // MARK: - Private functions

    private func getUsersList() async {
        do {
            await setLoadingState(state: .loading)

            let result = try await getUserListUseCase.execute(
                page: currentResult?.page ?? 1,
                seed: currentResult?.seed
            )

            guard let page = result.page else {
                await setLoadingState(state: .error)
                return
            }

            self.currentResult = .init(
                page: page + 1,
                seed: result.seed,
                users: result.users
            )

            await setUsersList(result.users)

            await setLoadingState(state: .loaded)
        } catch let error {
            print(error.localizedDescription)
            await setLoadingState(state: .error)
        }
    }

    // MARK: - MainActor methods

    @MainActor
    private func setUsersList(_ usersList: [UserModel]) {
        self.usersList.append(contentsOf: usersList)
    }

    @MainActor
    private func setLoadingState(state: ViewState) {
        self.state = state
    }
}
