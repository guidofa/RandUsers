//
//  UserModel.swift
//  RandUsers
//
//  Created by Guido Fabio on 7/3/25.
//

import Foundation

struct UserModel: Equatable, Identifiable {
    let id: String
    let email: String?
    let gender: String?
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

struct UserLocationModel {
    let city: String?
    let state: String?
    let streetName: String?
    let streetNumber: String?
}
