//
//  GetUserListUseCaseTests.swift
//  RandUsersTests
//
//  Created by Guido Fabio on 10/3/25.
//

@testable import RandUsers
import XCTest

final class GetUserListUseCaseTests: XCTestCase {

    var mockUserRepository: MockUserRepositoryImpl!

    var sut: GetUserListUseCase!

    override func setUpWithError() throws {
        self.mockUserRepository = MockUserRepositoryImpl()

        self.sut = GetUserListUseCaseImpl(userRepository: mockUserRepository)
    }

    override func tearDownWithError() throws {
        self.mockUserRepository = nil

        self.sut = nil
    }

    func testExecuteReturnsResultModel() async throws {
        // Given
        let mockResponse = MockResultModel.getMockResultModel()

        // When
        let response = try await sut.execute(page: 5, seed: "asdf")
        
        // Then
        XCTAssertEqual(mockUserRepository.getUsersCalled, true, "Should call the user repository")
        XCTAssertNotNil(mockResponse, "Result model should not be nil")
        XCTAssertEqual(response, mockResponse, "Should return the same result model")
    }

    func testWhenAPIFailsThrowsError() async {
        do {
            _ = try await sut.execute(page: 0, seed: nil)
            XCTFail("Expected error but got result")
        } catch {
            guard let urlError = error as? URLError else {
                XCTFail("Expected URLError")
                return
            }
            XCTAssertEqual(urlError.code, URLError.badServerResponse, "The error code should be badServerResponse")
        }
    }
    
}
