//
//  MockUserModel.swift
//  RandUsersTests
//
//  Created by Guido Fabio on 10/3/25.
//

@testable import RandUsers
import Foundation

class MockUserModel {
    static func getMockUserModelArray() -> [UserModel] {
        return [MockUserModel.getMockUser(), MockUserModel.getMockUser2(), MockUserModel.getMockUser3()]
    }

    static func getMockUser() -> UserModel {
        .init(
            id: "1",
            email: "john@example.com",
            gender: "male",
            location: UserLocationModel(
                city: "New York",
                state: "NY",
                streetName: "Main Street",
                streetNumber: "123"
            ),
            name: "John",
            phone: "123456789",
            picture: "picture.jpg",
            registeredDate: Date(),
            surname: "Doe",
            thumbnailPicture: "thumbnail.jpg"
        )
    }

    
    static func getMockUser2() -> UserModel {
        .init(
            id: "2",
            email: "jane@example.com",
            gender: "female",
            location: UserLocationModel(
                city: "Los Angeles",
                state: "CA",
                streetName: "Sunset Blvd",
                streetNumber: "456"
            ),
            name: "Jane",
            phone: "987654321",
            picture: "picture2.jpg",
            registeredDate: Date(),
            surname: "Smith",
            thumbnailPicture: "thumbnail2.jpg"
        )
    }

    static func getMockUser3() -> UserModel {
        .init(
            id: "3",
            email: "bob@example.com",
            gender: "male",
            location: UserLocationModel(
                city: "Chicago",
                state: "IL",
                streetName: "Michigan Ave",
                streetNumber: "789"
            ),
            name: "Bob",
            phone: "555123456",
            picture: "picture3.jpg",
            registeredDate: Date(),
            surname: "Johnson",
            thumbnailPicture: "thumbnail3.jpg"
        )
    }
}
