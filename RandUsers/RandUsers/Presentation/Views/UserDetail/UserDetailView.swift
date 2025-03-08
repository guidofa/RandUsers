//
//  UserDetailView.swift
//  RandUsers
//
//  Created by Guido Fabio on 8/3/25.
//

import SwiftUI

private extension LocalizedStringKey {
    static var gender: LocalizedStringKey { "Gender: " }
    static var registrationDate: LocalizedStringKey { "Registration Date: " }
}

private extension String {
    static var defaultProfileImageName: String { "person.fill" }
}

struct UserDetailView: View {
    var user: UserModel

    var body: some View {
        VStack(spacing: 12) {
            if let picture = user.picture {
                AsyncImage(url: URL(string: picture)) { phase in
                    if let image = phase.image {
                        image.resizable()
                    } else if phase.error != nil {
                        Image(systemName: .defaultProfileImageName)
                            .resizable()
                            .foregroundColor(Color.ruPrimary)
                    } else {
                        ProgressView()
                    }
                }
                .scaledToFill()
                .frame(width: 150, height: 150)
                .clipShape(Circle())
                .overlay(Circle().stroke(Color.black, lineWidth: 1))
                .shadow(radius: 1)
            }

            Text(user.completeName)
                .foregroundStyle(Color.ruPrimary)
                .font(.headline)

            InfoView(title: .gender, subtitle: user.gender ?? .empty)

            InfoView(title: .registrationDate, subtitle: user.registeredDate?.formatted() ?? .empty)

            InfoView(title: "Gender:", subtitle: user.gender ?? .empty)

            Spacer()
        }
        .padding(.vertical, 32)
    }
}

struct InfoView: View {
    let title: LocalizedStringKey
    let subtitle: String

    var body: some View {
        HStack(spacing: 4) {
            Text(title)
                .foregroundStyle(Color.ruPrimary)
                .font(.headline)

            Text(subtitle)
                .foregroundStyle(Color.ruPrimary)
                .font(.system(size: 18))
        }
    }
}

#Preview {
    UserDetailView(
        user: .init(
            id: "0",
            email: "johndoe@example.com",
            gender: "male",
            location: UserLocationModel(
                city: "Barcelona",
                state: "Barcelona",
                streetName: "Pujades",
                streetNumber: "99"
            ),
            name: "John",
            phone: "+34 60121212",
            picture: "https://randomuser.me/api/portraits/men/75.jpg",
            registeredDate: Date(),
            surname: "Fabio",
            thumbnailPicture: "https://randomuser.me/api/portraits/thumb/men/75.jpg"
        )
    )
}
