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

struct UserListView: View {
    @StateObject var viewModel: UserListViewModel

    @State private var selectedUser: UserModel?

    var body: some View {
        NavigationStack {
            Group {
                switch viewModel.state {
                case .loading:
                    ProgressView()

                case .loaded:
                    ScrollView {
                        LazyVStack(spacing: .largePadding) {
                            ForEach(viewModel.usersList) { user in
                                UserView(user: user)
                                    .onTapGesture {
                                        selectedUser = user
                                    }
                            }
                        }
                    }

                case .error:
                    Text( .genericError)
                }
            }
            .navigationTitle(.navigationTitle)
            .sheet(item: $selectedUser, content: { user in
                UserView(user: user)
            })
        }
        .task { [weak viewModel] in
            await viewModel?.trigger(.getUsersList)
        }
    }
}

struct UserView: View {
    let user: UserModel

    var body: some View {
        HStack(spacing: 12) {
            AsyncImage(url: URL(string: user.picture!)) { phase in
                if let image = phase.image {
                    image.resizable()
                } else if phase.error != nil {
                    Image(systemName: "person.fill")
                        .resizable()
                        .foregroundColor(.gray)
                } else {
                    ProgressView()
                }
            }
            .scaledToFill()
            .frame(width: 50, height: 50)
            .clipShape(Circle())
            .overlay(Circle().stroke(Color.gray, lineWidth: 1))
            .shadow(radius: 2)

            VStack(alignment: .leading, spacing: 4) {
                Text(user.completeName)
                    .font(.headline)
                Text(user.phone!)
                    .font(.subheadline)
                    .foregroundColor(.gray)
                Text(user.email!)
                    .font(.subheadline)
                    .foregroundColor(.blue)
            }

            Spacer()
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 10).fill(Color(.systemBackground)).shadow(radius: 2))
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
