//
//  UserModel.swift
//  RandUsers
//
//  Created by Guido Fabio on 7/3/25.
//

import Foundation

struct UserModel {
    let id: String
    let email: String?
    let gender: String?
    let location: UserLocationModel?
    let name: String?
    let phone: String?
    let picture: String?
    let registeredDate: Date?
    let surname: String?

    var completeName: String {
        "\(name ?? "-") \(surname ?? "-")"
    }
}

struct UserLocationModel {
    let city: String?
    let state: String?
    let streetName: String?
    let streetNumber: String?
}
