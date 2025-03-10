//
//  UserModel.swift
//  RandUsers
//
//  Created by Guido Fabio on 7/3/25.
//

import Foundation

struct UserModel: Equatable, Identifiable, Hashable {
    let id: String
    let email: String?
    let gender: String?
    var isDeleted: Bool = false
    let location: UserLocationModel?
    let name: String?
    let phone: String?
    let picture: String?
    let registeredDate: Date?
    let surname: String?
    let thumbnailPicture: String?

    var completeName: String {
        "\(name ?? .empty) \(surname ?? .empty)"
    }

    static func == (lhs: UserModel, rhs: UserModel) -> Bool {
        return lhs.id == rhs.id
    }
}

extension UserModel {
    func mapToLocal() -> UserLocalResponse {
        let userLocalResponse = UserLocalResponse()

        userLocalResponse.id = id
        userLocalResponse.email = email
        userLocalResponse.gender = gender
        userLocalResponse.isDeleted = isDeleted
        userLocalResponse.location = location?.mapToLocal()
        userLocalResponse.name = name
        userLocalResponse.phone = phone
        userLocalResponse.picture = picture
        userLocalResponse.registeredDate = registeredDate
        userLocalResponse.surname = surname
        userLocalResponse.thumbnailPicture = thumbnailPicture

        return userLocalResponse
    }
}

struct UserLocationModel: Hashable {
    let city: String?
    let state: String?
    let streetName: String?
    let streetNumber: String?
}

extension UserLocationModel {
    func mapToLocal() -> UserLocalLocationResponse {
        let userLocalLocationResponse = UserLocalLocationResponse()

        userLocalLocationResponse.city = city
        userLocalLocationResponse.state = state
        userLocalLocationResponse.streetName = streetName
        userLocalLocationResponse.streetNumber = streetNumber

        return userLocalLocationResponse
    }
}
