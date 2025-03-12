//
//  UserDetailView.swift
//  RandUsers
//
//  Created by Guido Fabio on 8/3/25.
//

import SwiftUI

private extension CGFloat {
    static var smallPadding: Self { 4 }
    static var mediumPadding: Self { 8 }
    static var defaultPadding: Self { 12 }
    static var largePadding: Self { 16 }
    static var extraLargePadding: Self { 32 }
}

private extension LocalizedStringKey {
    static var address: LocalizedStringKey { "Address:" }
    static var email: LocalizedStringKey { "Email:" }
    static var gender: LocalizedStringKey { "Gender:" }
    static var title: LocalizedStringKey { "Random User" }
    static var registrationDate: LocalizedStringKey { "Registered:" }
}

private extension String {
    static var defaultProfileImageName: String { "person.fill" }
}

struct UserDetailView: View {
    @Environment(\.dismiss) private var dismiss

    var user: UserModel

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: .extraLargePadding) {
                    if let picture = user.picture {
                        AsyncImage(url: URL(string: picture)) { phase in
                            if let image = phase.image {
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                            } else if phase.error != nil {
                                Image(systemName: .defaultProfileImageName)
                                    .resizable()
                                    .scaledToFill()
                                    .foregroundColor(.gray)
                            } else {
                                ProgressView()
                            }
                        }
                        .frame(width: 150, height: 150)
                        .clipShape(Circle())
                        .overlay(Circle().stroke(.ruPrimary, lineWidth: 4))
                        .shadow(radius: 10)
                        .padding(.top, .largePadding)
                    }

                    Text(user.completeName)
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)

                    VStack(spacing: .largePadding) {
                        InfoView(
                            title: .gender,
                            subtitle: user.gender ?? .empty
                        )

                        InfoView(
                            title: .registrationDate,
                            subtitle: user.registeredDate?.formatted() ?? .empty
                        )

                        InfoView(
                            title: .address,
                            subtitle: user.location?.address ?? .empty
                        )

                        InfoView(
                            title: .email,
                            subtitle: user.email ?? .empty
                        )
                    }
                    .padding()
                    .background(Color(UIColor.secondarySystemBackground))
                    .cornerRadius(12)
                    .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)

                    Spacer()
                }
                .padding()
            }
            .background(Color(UIColor.systemGroupedBackground).ignoresSafeArea())
            .navigationTitle(Text(.title))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                            .tint(Color.primary)
                    }
                }
            }
        }
    }
}

struct InfoView: View {
    let title: LocalizedStringKey
    let subtitle: String

    var body: some View {
        HStack {
            Text(title)
                .font(.headline)
                .foregroundColor(.secondary)
                .frame(width: 120, alignment: .leading)

            Text(subtitle)
                .font(.subheadline)
                .foregroundColor(.primary)

            Spacer()
        }
    }
}

struct UserDetailView_Previews: PreviewProvider {
    static var previews: some View {
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
}
