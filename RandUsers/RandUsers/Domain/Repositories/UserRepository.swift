//
//  UserRepository.swift
//  RandUsers
//
//  Created by Guido Fabio on 9/3/25.
//

import Foundation

protocol UserRepository {
    func getUsers(page: Int, seed: String?) async throws -> ResultModel
}
