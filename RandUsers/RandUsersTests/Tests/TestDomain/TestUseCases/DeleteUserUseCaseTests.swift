//
//  DeleteUserUseCaseTests.swift
//  RandUsersTests
//
//  Created by Guido Fabio on 10/3/25.
//

@testable import RandUsers
import XCTest

final class DeleteUserUseCaseTests: XCTestCase {

    var mockUserLocalRepository: MockUserLocalRepository!
    var sut: DeleteUserUseCase!

    override func setUpWithError() throws {
        self.mockUserLocalRepository = MockUserLocalRepository()
        self.sut = DeleteUserUseCaseImpl(userLocalRepository: mockUserLocalRepository)
    }

    override func tearDownWithError() throws {
        self.mockUserLocalRepository = nil
        self.sut = nil
    }

    func testDeleteUserReturnsDeletedUser() async {
        // Given
        let mockUserModel = MockUserModel.getMockUser3()

        // When
        let deletedUserModel = await sut.execute(userModel: mockUserModel)

        // Then
        XCTAssertEqual(mockUserLocalRepository.deleteUserCalled, true, "Expected deleteUser to be called")
        XCTAssertNotNil(deletedUserModel, "Expected deletedUserModel to not be nil")
        XCTAssertEqual(deletedUserModel, mockUserModel, "Expected deleted user model to equal the provided user model")
    }

    func testDeleteUserReturnsNilWhenFailed() async {
        // Given
        var mockUserModel = MockUserModel.getMockUser2()
        mockUserModel.id = "forceFail"

        // When
        let deletedUserModel = await sut.execute(userModel: mockUserModel)

        // Then
        XCTAssertNil(deletedUserModel, "If something fail delete should returns nil")
    }

}
