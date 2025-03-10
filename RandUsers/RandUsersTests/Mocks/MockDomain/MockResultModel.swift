//
//  MockResultModel.swift
//  RandUsersTests
//
//  Created by Guido Fabio on 10/3/25.
//

@testable import RandUsers
import Foundation

struct MockResultModel {
    static func getMockResultModel() -> ResultModel {
        .init(
            page: 3,
            seed: "mockseed",
            users: [
                .init(
                    id: "1",
                    email: "john@example.com",
                    gender: "male",
                    location: .init(
                        city: "Rosario",
                        state: "Sante Fe",
                        streetName: "Sin Nombre",
                        streetNumber: "732"
                    ),
                    name: "John",
                    phone: "+32 323 123 4",
                    picture: "picture.jpg",
                    registeredDate: Date(),
                    surname: "Doe",
                    thumbnailPicture: "picture_thumbnail.jpg"
                ),
                .init(
                    id: "2",
                    email: "jane@example.com",
                    gender: "female",
                    location: .init(
                        city: "New York",
                        state: "NY",
                        streetName: "Broadway",
                        streetNumber: "101"
                    ),
                    name: "Jane",
                    phone: "+1 555 678 9012",
                    picture: "jane_picture.jpg",
                    registeredDate: Date(),
                    surname: "Smith",
                    thumbnailPicture: "jane_thumbnail.jpg"
                )
            ]
        )
    }
}
