//
//  ResultMapper.swift
//  RandUsers
//
//  Created by Guido Fabio on 9/3/25.
//

import Foundation

extension ResultResponse {
    func toResultModel() -> ResultModel {
        return .init(
            page: self.info.page,
            seed: self.info.seed,
            users: self.toUserModels()
        )
    }
}
