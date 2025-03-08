//
//  UserListView.swift
//  RandUsers
//
//  Created by Guido Fabio on 7/3/25.
//

import SwiftUI

struct UserListView: View {
    @StateObject var viewModel: UserListViewModel

    var body: some View {
        NavigationStack {
            Group {
                switch viewModel.state {
                case .loading:
                    ProgressView()

                case .loaded:
                    ScrollView {
                        LazyVStack(spacing: 20) {
                            ForEach(viewModel.usersList) { user in
                                UserView(user: user)
                            }
                        }
                    }
                case .error:
                    Text("An error ocurred")
                }
            }
            .navigationTitle("Random Users")
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
