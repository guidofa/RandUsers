//
//  ResultModel.swift
//  RandUsers
//
//  Created by Guido Fabio on 9/3/25.
//

import Foundation

struct ResultModel: Hashable {
    let page: Int?
    let seed: String?
    var users: [UserModel]
}

extension ResultModel {
    func mapToLocal() -> ResultLocalResponse {
        let resultLocalResponse = ResultLocalResponse()
        resultLocalResponse.page = page ?? 1
        resultLocalResponse.seed = seed
        for user in users {
            resultLocalResponse.users.append(user.mapToLocal())
        }
        return resultLocalResponse
    }
}
