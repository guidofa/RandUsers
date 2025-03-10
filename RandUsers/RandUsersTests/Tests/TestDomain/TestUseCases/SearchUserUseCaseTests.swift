//
//  SearchUserUseCaseTests.swift
//  RandUsersTests
//
//  Created by Guido Fabio on 10/3/25.
//

@testable import RandUsers
import XCTest

final class SearchUserUseCaseTests: XCTestCase {

    var mockUserLocalRepository: MockUserLocalRepository!
    var sut: SearchUserUseCase!

    override func setUpWithError() throws {
        self.mockUserLocalRepository = MockUserLocalRepository()
        self.sut = SearchUserUseCaseImpl(userLocalRepository: mockUserLocalRepository)
    }

    override func tearDownWithError() throws {
        self.mockUserLocalRepository = nil
        self.sut = nil
    }

    func testSearchUserReturningDataWhenSuccess() async {
        // Given
        let mockFilteredUsers = MockUserModel.getMockUserModelArray()
        
        // When
        let filteredUsers = await sut.execute(searchTerm: "success")

        // Then
        XCTAssertEqual(mockUserLocalRepository.searchUsersCalled, true, "Expected searchUsers to be called")
        XCTAssertNotNil(filteredUsers, "Expected filteredUsers to not be nil")
        XCTAssertEqual(filteredUsers, mockFilteredUsers, "Expected filteredUsers model to equal the provided filteredUsers")
    }

    func testSearchUserReturningEmptyArrayWhenFailed() async {
        // Given
        let searchTerm = "forceFail"

        // When
        let filteredArray = await sut.execute(searchTerm: searchTerm)

        // Then
        XCTAssertEqual([], filteredArray, "Filtered array when fail should be an empty array")
    }

}
