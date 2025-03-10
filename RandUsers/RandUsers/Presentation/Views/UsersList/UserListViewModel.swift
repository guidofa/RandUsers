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
    @Published var usersListToShow = [UserModel]()

    // MARK: - Private vars

    private var currentResult: ResultModel?
    private var usersList: [UserModel] = []

    // MARK: - Public Enums

    enum TriggerAction {
        case deleteUser(UserModel)
        case filter(searchTerm: String)
        case getUsersList
    }

    enum ViewState {
        case error
        case loaded
        case loading
    }

    // MARK: - UseCases

    private let deleteUserUseCase: DeleteUserUseCase
    private let getUserListUseCase: GetUserListUseCase
    private let searchUserUseCase: SearchUserUseCase

    // MARK: - Init

    init(
        deleteUserUseCase: DeleteUserUseCase,
        getUserListUseCase: GetUserListUseCase,
        searchUserUseCase: SearchUserUseCase,
        usersList: [UserModel] = [UserModel]()
    ) {
        self.deleteUserUseCase = deleteUserUseCase
        self.getUserListUseCase = getUserListUseCase
        self.searchUserUseCase = searchUserUseCase
        self.usersListToShow = usersList
    }

    // MARK: - Public Functions

    func trigger(_ action: TriggerAction) async {
        switch action {
        case .deleteUser(let user):
            await deleteUser(user)

        case .filter(let searchTerm):
            if searchTerm.isEmpty {
                await setFilteredUsersList(usersList)
                return
            }

            await searchUsers(withTerm: searchTerm)

        case .getUsersList:
            await getUsersList()
        }
    }

    // MARK: - Private functions

    private func deleteUser(_ user: UserModel) async {
        var userToDelete = user
        userToDelete.isDeleted = true

        guard let deletedUser = await deleteUserUseCase.execute(userModel: userToDelete),
              let index = usersList.firstIndex(where: { $0.id == deletedUser.id })
        else { return }

        usersList[index].isDeleted = true
        await setFilteredUsersList(usersList)
    }

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

            self.usersList.append(contentsOf: result.users)
            await setUsersListToShow(result.users)

            await setLoadingState(state: .loaded)
        } catch let error {
            print(error.localizedDescription)
            await setLoadingState(state: .error)
        }
    }

    private func searchUsers(withTerm searchTerm: String) async {
        let filteredUsers = await searchUserUseCase.execute(searchTerm: searchTerm)
        await setFilteredUsersList(filteredUsers)
    }

    // MARK: - MainActor methods

    @MainActor
    private func setFilteredUsersList(_ usersList: [UserModel]) {
        self.usersListToShow = usersList.filter({ !$0.isDeleted })
    }

    @MainActor
    private func setUsersListToShow(_ usersList: [UserModel]) {
        self.usersListToShow.append(contentsOf: usersList.filter({ !$0.isDeleted }))
    }

    @MainActor
    private func setLoadingState(state: ViewState) {
        self.state = state
    }
}
