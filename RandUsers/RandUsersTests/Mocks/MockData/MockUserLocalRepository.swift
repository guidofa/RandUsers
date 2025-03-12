//
//  MockUserLocalRepository.swift
//  RandUsersTests
//
//  Created by Guido Fabio on 10/3/25.
//

@testable import RandUsers
import Foundation

class MockUserLocalRepository: UserLocalRepository {
    var deleteUserCalled = false
    func deleteUser(userModel: UserModel) async -> UserModel? {
        deleteUserCalled = true
        return userModel.id == "forceFail" ? nil : userModel
    }
    
    var getUserModelCalled = false
    func getUserModel(page: Int, seed: String?) async -> ResultModel? {
        getUserModelCalled = true
        return seed == "fail" ? nil : MockResultModel.getMockResultModel()
    }
    
    var saveUserModelCalled = false
    func saveUserModel(_ userModel: ResultModel) async {
        saveUserModelCalled = true
    }
    
    var searchUsersCalled = true
    func searchUsers(searchTerm: String) async -> [UserModel] {
        searchUsersCalled = true
        return searchTerm == "forceFail" ? [] : MockUserModel.getMockUserModelArray()
    }
}
