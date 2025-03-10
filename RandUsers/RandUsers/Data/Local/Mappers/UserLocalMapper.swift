//
//  UserLocalMapper.swift
//  RandUsers
//
//  Created by Guido Fabio on 9/3/25.
//

import Foundation

extension UserLocalResponse {
    func mapToModel() -> UserModel {
        .init(
            id: id,
            email: email,
            gender: gender,
            isDeleted: isDeleted ?? false,
            location: location?.mapToModel(),
            name: name,
            phone: phone,
            picture: picture,
            registeredDate: registeredDate,
            surname: surname,
            thumbnailPicture: thumbnailPicture
        )
    }
}

extension UserLocalLocationResponse {
    func mapToModel() -> UserLocationModel {
        .init(
            city: city,
            state: state,
            streetName: streetName,
            streetNumber: streetNumber
        )
    }
}
