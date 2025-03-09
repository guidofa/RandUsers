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
    static var genericError: Self { "Ooops... there was an error!" }
    static var navigationTitle: Self { "Random Users" }
}

private extension String {
    static var defaultProfileImageName: String { "person.fill" }
}

struct UserListView: View {
    @StateObject var viewModel: UserListViewModel

    @State private var selectedUser: UserModel?

    var body: some View {
        NavigationStack {
            Group {
                ZStack {
                    ListView(viewModel: viewModel, selectedUser: $selectedUser)

                    if viewModel.state == .loading {
                        Color.black.opacity(0.5)
                            .edgesIgnoringSafeArea(.all)
                            .overlay(
                                ProgressView()
                                    .controlSize(.large)
                                    .tint(.white)
                            )
                    }
                }
            }
            .navigationTitle(.navigationTitle)
            .sheet(item: $selectedUser, content: { user in
                UserDetailView(user: user)
            })
        }
        .task { [weak viewModel] in
            await viewModel?.trigger(.getUsersList(1))
        }
    }
}

private struct ListView: View {
    @StateObject var viewModel: UserListViewModel

    @Binding var selectedUser: UserModel?

    var body: some View {
        ScrollView {
            LazyVStack(spacing: .largePadding) {
                ForEach(viewModel.usersList) { user in
                    UserView(user: user)
                        .onTapGesture { selectedUser = user }
                        .onAppear { [weak viewModel] in
                            if user == viewModel?.usersList.last {
                                Task { [weak viewModel] in
                                    await viewModel?.trigger(.getUsersList(2))
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
                .scaledToFill()
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

#Preview {
    UserListView(
        viewModel: .init(
            getUserListUseCase: GetUserListUseCaseImpl(
                userRepository: UserRepositoryImpl()
            )
        )
    )
}
