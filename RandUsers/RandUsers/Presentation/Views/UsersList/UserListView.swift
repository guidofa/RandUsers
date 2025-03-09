//
//  UserListView.swift
//  RandUsers
//
//  Created by Guido Fabio on 7/3/25.
//

import SwiftUI

private extension CGFloat {
    static var largePadding: Self { 32 }
}

private extension LocalizedStringKey {
    static var genericError: Self { "❌ Ooops... there was an error!" }
    static var navigationTitle: Self { "Random Users" }
    static var searchPlaceholder: Self { "Search by name, surname or email" }
}

private extension String {
    static var defaultProfileImageName: String { "person.fill" }
    static var searchIconName: String { "magnifyingglass" }
}

struct UserListView: View {
    @StateObject var viewModel: UserListViewModel

    @State private var debouncedSearchText: String = .empty
    @State private var searchText: String = .empty

    @State private var selectedUser: UserModel?

    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                SearchView(searchText: $searchText, onDebounce: { value in
                    debouncedSearchText = value
                    Task { [weak viewModel] in
                        await viewModel?.trigger(.filter(searchTerm: value))
                    }
                })

                ListView(
                    viewModel: viewModel,
                    selectedUser: $selectedUser,
                    searchText: $searchText
                )

                if viewModel.state == .loading {
                    ProgressView()
                        .controlSize(.large)
                        .tint(.ruPrimary)
                } else if viewModel.state == .error {
                    Text(.genericError)
                        .foregroundColor(.red)
                        .font(.callout)
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

    @Binding var selectedUser: UserModel?
    @Binding var searchText: String

    var body: some View {
        ScrollView {
            LazyVStack(spacing: .largePadding) {
                ForEach(viewModel.usersListToShow) { user in
                    UserView(user: user)
                        .onTapGesture { selectedUser = user }
                        .onAppear { [weak viewModel] in
                            guard let viewModel = viewModel else { return }
                            let isLastUser = user == viewModel.usersListToShow.last
                            let isNotLoading = viewModel.state != .loading
                            if isLastUser && isNotLoading && searchText.isEmpty {
                                Task {
                                    await viewModel.trigger(.getUsersList)
                                }
                            }
                        }
                }
            }
        }
    }
}

private struct UserView: View {
    let user: UserModel

    var body: some View {
        HStack(spacing: 12) {
            if let picture = user.thumbnailPicture {
                AsyncImage(url: URL(string: picture)) { phase in
                    if let image = phase.image {
                        image.resizable()
                    } else if phase.error != nil {
                        Image(systemName: .defaultProfileImageName)
                            .resizable()
                            .foregroundColor(.gray)
                    } else {
                        ProgressView()
                    }
                }
                .scaledToFit()
                .frame(width: 50, height: 50)
                .clipShape(Circle())
                .overlay(Circle().stroke(Color.black, lineWidth: 1))
                .shadow(radius: 1)
            }

            VStack(alignment: .leading, spacing: 8) {
                Text(user.completeName)
                    .font(.headline)

                VStack(alignment: .leading, spacing: 4) {
                    Text(user.phone ?? .empty)
                        .font(.subheadline)
                        .foregroundColor(.ruPrimary)

                    Text(user.email ?? .empty)
                        .font(.subheadline)
                        .foregroundColor(.ruPrimary)
                }
            }

            Spacer(minLength: 4)
        }
        .padding(8)
        .background(RoundedRectangle(cornerRadius: 10).fill(Color.ruSecondary).shadow(radius: 4))
        .padding(.horizontal, 8)
    }
}

struct SearchView: View {
    @Binding var searchText: String
    var onDebounce: (String) -> Void
    @State private var debounceTimer: Timer?

    var body: some View {
        HStack {
            Image(systemName: .searchIconName)
                .foregroundColor(.ruPrimary)
            TextField(.searchPlaceholder, text: $searchText)
                .foregroundColor(.ruPrimary)
        }
        .padding(10)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color.ruPrimary, lineWidth: 1)
        )
        .padding(.horizontal)
        .onChange(of: searchText) { newValue in
            debounceTimer?.invalidate()
            debounceTimer = Timer.scheduledTimer(withTimeInterval: 0.8, repeats: false) { _ in
                onDebounce(newValue)
            }
        }
    }
}

#Preview {
    UserListView(
        viewModel: .init(
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
