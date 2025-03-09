//
//  ResultLocalMapper.swift
//  RandUsers
//
//  Created by Guido Fabio on 9/3/25.
//

extension ResultLocalResponse {
    func mapToModel() -> ResultModel {
        .init(
            page: page,
            seed: seed,
            users: users.compactMap { $0.mapToModel() }
        )
    }
}
