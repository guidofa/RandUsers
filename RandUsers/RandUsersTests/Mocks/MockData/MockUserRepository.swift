//
//  MockUserRepository.swift
//  RandUsersTests
//
//  Created by Guido Fabio on 10/3/25.
//

@testable import RandUsers
import Foundation

class MockUserRepositoryImpl: UserRepository {
    var getUsersCalled = false
    func getUsers(page: Int, seed: String?) async throws -> ResultModel {
        getUsersCalled = true
        if page == 0 {
            throw URLError(.badServerResponse)
        } else {
            return MockResultModel.getMockResultModel()
        }
    }
}
