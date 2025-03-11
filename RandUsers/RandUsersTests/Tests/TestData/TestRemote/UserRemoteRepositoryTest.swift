//
//  UserRemoteRepositoryTest.swift
//  RandUsers
//
//  Created by Guido Fabio on 11/3/25.
//

@testable import RandUsers
import XCTest

final class UserRemoteRepositoryTest: XCTestCase {

    var session: URLSession!
    var mockUserLocalRepository: MockUserLocalRepository!

    var sut: UserRepository!
    
    @MainActor
    override func setUpWithError() throws {
        self.session = URLSession.shared
        self.mockUserLocalRepository = MockUserLocalRepository()

        self.sut = UserRepositoryImpl(
            session: session,
            userLocalRepository: mockUserLocalRepository
        )
    }

    @MainActor
    override func tearDownWithError() throws {
        self.session = nil
        self.sut = nil
        self.mockUserLocalRepository = nil
    }

    func testGetUsersSuccess() async throws {
        // Given
        let page = 1
        let seed: String? = nil

        // When
        let result = try await sut.getUsers(page: page, seed: seed)

        // Then
        XCTAssertNotNil(result)
    }
}
