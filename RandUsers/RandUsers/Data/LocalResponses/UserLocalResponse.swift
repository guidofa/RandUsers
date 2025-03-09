//
//  UserLocalResponse.swift
//  RandUsers
//
//  Created by Guido Fabio on 9/3/25.
//

import Foundation
import RealmSwift

class UserLocalResponse: Object {
   @Persisted var id: String
   @Persisted var email: String?
   @Persisted var gender: String?
   @Persisted var location: UserLocalLocationResponse?
   @Persisted var name: String?
   @Persisted var phone: String?
   @Persisted var picture: String?
   @Persisted var registeredDate: Date?
   @Persisted var surname: String?
   @Persisted var thumbnailPicture: String?
}

class UserLocalLocationResponse: Object {
   @Persisted var city: String?
   @Persisted var state: String?
   @Persisted var streetName: String?
   @Persisted var streetNumber: String?
}

class UserLocalLocationStreetResponse: Object {
   @Persisted var city: String?
   @Persisted var state: String?
   @Persisted var streetName: String?
   @Persisted var streetNumber: String?
}

extension UserLocalLocationStreetResponse {
    func mapToModel() -> UserLocationModel {
        .init(
            city: city,
            state: state,
            streetName: streetName,
            streetNumber: streetNumber
        )
    }
}
