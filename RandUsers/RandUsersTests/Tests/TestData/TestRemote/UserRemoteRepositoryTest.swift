//
//  UserRemoteRepositoryTest.swift
//  RandUsers
//
//  Created by Guido Fabio on 11/3/25.
//

@testable import RandUsers
import XCTest

final class UserRemoteRepositoryTest: XCTestCase {

    var mockUserLocalRepository: MockUserLocalRepository!
    var networkManager: MockNetworkManager!

    var sut: UserRepository!
    
    @MainActor
    override func setUpWithError() throws {
        self.mockUserLocalRepository = MockUserLocalRepository()
        self.networkManager = MockNetworkManager()

        self.sut = UserRepositoryImpl(
            networkManager: networkManager,
            userLocalRepository: mockUserLocalRepository
        )
    }

    @MainActor
    override func tearDownWithError() throws {
        self.mockUserLocalRepository = nil
        self.networkManager = nil

        self.sut = nil
    }

    
    func testGetUsersSuccess() async throws {
        // Given
        let page = 1

        // When
        let result = try await sut.getUsers(page: page, seed: "fail")

        // Then
        XCTAssert(networkManager.fetchDataCalled)
        XCTAssertNotNil(result)
    }

}
