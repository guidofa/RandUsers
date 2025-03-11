//
//  UserListView.swift
//  RandUsers
//
//  Created by Guido Fabio on 7/3/25.
//

import SwiftUI

private extension CGFloat {
    static var smallPadding: Self { 4 }
    static var mediumPadding: Self { 8 }
    static var defaultPadding: Self { 12 }
    static var largePadding: Self { 16 }
}

private extension LocalizedStringKey {
    static var emptyStateMessage: Self { "No Contacts Found." }
    static var genericError: Self { "❌ Ooops... there was an error!" }
    static var navigationTitle: Self { "Random Users" }
    static var searchPlaceholder: Self { "Search by name, surname or email" }
}

private extension String {
    static var defaultProfileImageName: Self { "person.fill" }
    static var deleteIcon: Self { "xmark.circle.fill" }
    static var searchIconName: Self { "magnifyingglass" }
}

struct UserListView: View {
    @StateObject var viewModel: UserListViewModel

    @State private var debouncedSearchText: String = .empty
    @State private var selectedUser: UserModel?
    @State private var searchText: String = .empty

    var body: some View {
        NavigationStack {
            VStack(spacing: .smallPadding) {
                SearchView(searchText: $searchText, onDebounce: { value in
                    debouncedSearchText = value
                    Task { [weak viewModel] in
                        await viewModel?.trigger(.filter(searchTerm: value))
                    }
                })

                if viewModel.usersListToShow.isEmpty {
                    Spacer(minLength: .zero)

                    Text(.emptyStateMessage)
                        .font(.title3)
                        .foregroundStyle(.ruPrimary)

                    Spacer(minLength: .zero)
                } else {
                    ListView(
                        viewModel: viewModel,
                        searchText: $searchText,
                        selectedUser: $selectedUser
                    )

                    if viewModel.state == .loading {
                        ProgressView()
                            .controlSize(.large)
                            .tint(.ruPrimary)
                    } else if viewModel.state == .error {
                        Text(.genericError)
                            .foregroundColor(.red)
                            .font(.headline)
                    }
                }
            }
            .navigationTitle(.navigationTitle)
            .sheet(item: $selectedUser, content: { user in
                UserDetailView(user: user)
            })
        }
        .task { [weak viewModel] in
            await viewModel?.trigger(.getUsersList)
        }
    }
}

private struct ListView: View {
    @StateObject var viewModel: UserListViewModel

    @Binding var searchText: String
    @Binding var selectedUser: UserModel?

    private func loadMoreIfNeeded(for user: UserModel) {
        let isLastUser = user == viewModel.usersListToShow.last
        let isNotLoading = viewModel.state != .loading
        if isLastUser && isNotLoading && searchText.isEmpty {
            Task {
                await viewModel.trigger(.getUsersList)
            }
        }
    }

    var body: some View {
        ScrollView {
            LazyVStack(spacing: .largePadding) {
                ForEach(viewModel.usersListToShow) { user in
                    UserView(user: user, onDelete: {
                        Task { [weak viewModel] in
                            await viewModel?.trigger(.deleteUser(user))
                        }
                    })
                    .onTapGesture { selectedUser = user }
                    .onAppear {
                        loadMoreIfNeeded(for: user)
                    }
                }
            }
            .padding(.vertical, .smallPadding)
        }
    }
}

struct SearchView: View {
    @State private var debounceTimer: Timer?
    @Binding var searchText: String

    var onDebounce: (String) -> Void

    var body: some View {
        HStack {
            Image(systemName: .searchIconName)
                .foregroundColor(.ruPrimary)

            TextField(.searchPlaceholder, text: $searchText)
                .foregroundColor(.ruPrimary)
                .padding(.mediumPadding)
        }
        .padding(.horizontal, .largePadding)
        .background(
            RoundedRectangle(cornerRadius: .defaultPadding)
                .fill(Color(UIColor.systemFill))
                .shadow(color: Color.black.opacity(0.1), radius: .smallPadding, x: 0, y: 1)
        )
        .padding(.horizontal, .defaultPadding)
        .padding(.vertical, .mediumPadding)
        .onChange(of: searchText) { newValue in
            debounceTimer?.invalidate()
            debounceTimer = Timer.scheduledTimer(withTimeInterval: 0.8, repeats: false) { _ in
                onDebounce(newValue)
            }
        }
    }
}

private struct UserView: View {
    let user: UserModel
    let onDelete: () -> Void

    var body: some View {
        HStack(alignment: .top, spacing: .largePadding) {
            if let picture = user.thumbnailPicture {
                AsyncImage(url: URL(string: picture)) { phase in
                    if let image = phase.image {
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                    } else if phase.error != nil {
                        Image(systemName: .defaultProfileImageName)
                            .resizable()
                            .scaledToFit()
                            .foregroundColor(.gray)
                    } else {
                        ProgressView()
                    }
                }
                .frame(width: 60, height: 60)
                .clipShape(Circle())
                .overlay(Circle().stroke(.ruPrimary, lineWidth: 1))
                .shadow(radius: .smallPadding)
            }

            VStack(alignment: .leading, spacing: .smallPadding) {
                Text(user.completeName)
                    .font(.headline)
                    .foregroundColor(.primary)

                VStack(alignment: .leading, spacing: .smallPadding) {
                    if let phone = user.phone, !phone.isEmpty {
                        Text(phone)
                    }

                    if let email = user.email, !email.isEmpty {
                        Text(email)
                    }
                }
                .font(.footnote)
                .foregroundColor(.ruPrimary)
            }

            Spacer(minLength: .smallPadding)

            Button(action: onDelete) {
                Image(systemName: .deleteIcon)
                    .font(.title2)
                    .foregroundColor(.red)
            }
        }
        .padding(.defaultPadding)
        .background(
            RoundedRectangle(cornerRadius: .defaultPadding)
                .fill(Color(.ruTeritiary))
                .shadow(color: Color.black.opacity(0.5), radius: .smallPadding, x: 0, y: 2)
        )
        .padding(.horizontal, .mediumPadding)
    }
}

#Preview {
    UserListView(
        viewModel: .init(
            deleteUserUseCase: DeleteUserUseCaseImpl(
                userLocalRepository: UserLocalRepositoryImpl()
            ),
            getUserListUseCase: GetUserListUseCaseImpl(
                userRepository: UserRepositoryImpl(
                    userLocalRepository: UserLocalRepositoryImpl()
                )
            ),
            searchUserUseCase: SearchUserUseCaseImpl(
                userLocalRepository: UserLocalRepositoryImpl()
            )
        )
    )
}
