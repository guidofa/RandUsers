//
//  UserResponse.swift
//  RandUsers
//
//  Created by Guido Fabio on 7/3/25.
//

import Foundation

struct UserResponse: Codable {
    let email: String?
    let gender: String?
    let location: UserLocationResponse?
    let login: UserLoginResponse?
    let name: UserNameResponse?
    let phone: String?
    let picture: UserPictureResponse?
    let registered: UserRegisteredResponse?
}

struct UserLocationResponse: Codable {
    let city: String?
    let state: String?
    let street: UserLocationStreetResponse?
}

struct UserLocationStreetResponse: Codable {
    let name: String?
    let number: Int?
}

struct UserLoginResponse: Codable {
    let uuid: String?
}

struct UserNameResponse: Codable {
    let first: String?
    let last: String?
}

struct UserPictureResponse: Codable {
    let large: String?
    let medium: String?
    let thumbnail: String?
}

struct UserRegisteredResponse: Codable {
    let date: String?
}
