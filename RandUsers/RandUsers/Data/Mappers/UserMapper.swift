//
//  UserMapper.swift
//  RandUsers
//
//  Created by Guido Fabio on 7/3/25.
//

import Foundation

extension Results {
    func toUserModels() -> [UserModel] {
        guard let results else { return [] }

        return results.compactMap { result in
                guard let id = result.login?.uuid else {
                    return nil
                }

                return UserModel(
                    id: id,
                    email: result.email,
                    gender: result.gender,
                    location: .init(
                        city: result.location?.city,
                        state: result.location?.state,
                        streetName: result.location?.street?.name,
                        streetNumber: "\(result.location?.street?.number ?? 0)"
                    ),
                    name: result.name?.first,
                    phone: result.phone,
                    picture: result.picture?.large,
                    registeredDate: result.registered?.date?.toDate(),
                    surname: result.name?.last
                )
        }
    }
}
