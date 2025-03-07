//
//  UserResponse.swift
//  RandUsers
//
//  Created by Guido Fabio on 7/3/25.
//

import Foundation

struct UserListResponse: Codable {
    let results: [UserResponse]
}

struct UserResponse: Codable {
    let gender: String
//    let location: UserLocationResponse
//    let name: String
//    let phone: String
//    let picture: String
//    let registeredDate: String
//    let surname: String
}

struct UserLocationResponse: Codable {
    let city: String
    let state: String
    let street: String
}
