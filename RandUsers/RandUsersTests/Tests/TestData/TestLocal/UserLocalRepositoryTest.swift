//
//  UserLocalRepositoryTest.swift
//  RandUsersTests
//
//  Created by Guido Fabio on 10/3/25.
//

@testable import RandUsers
import XCTest
import RealmSwift

final class UserLocalRepositoryTest: XCTestCase {

    var sut: UserLocalRepository!
    var realm: Realm!

    @MainActor
    override func setUpWithError() throws {
        var realmConfiguration = Realm.Configuration()
        realmConfiguration.fileURL = realmConfiguration.fileURL!.deletingLastPathComponent().appendingPathComponent("test")
        realmConfiguration.inMemoryIdentifier = self.name
        realm = try? Realm(configuration: realmConfiguration)

        self.sut = UserLocalRepositoryImpl(realm: realm)
    }

    @MainActor
    override func tearDownWithError() throws {
        try! realm.write{
            realm.deleteAll()
        }

        sut = nil
    }

    @MainActor
    func testSaveUserModel() async throws {
        // Given
        let mockResponse = MockResultModel.getMockResultModel()

        // When
        await sut.saveUserModel(mockResponse)
        let responseSaved = realm.objects(ResultLocalResponse.self)

        // Then
        XCTAssertNotNil(responseSaved)
    }

    @MainActor
    func testGetUsersModelsSuccess() async throws {
        // Given
        let mockResult = MockResultModel.getMockResultModel()

        try? realm.write {
            let mockResultLocal = mockResult.mapToLocal()
            realm.add(mockResultLocal)
        }

        // When
        let result = await sut.getUserModel(page: 3, seed: "mockseed")

        // Then
        XCTAssertNotNil(result)
        XCTAssertEqual(result, MockResultModel.getMockResultModel())
    }

    @MainActor
    func testGetUsersModelsError() async throws {
        // Given
        let mockResult = MockResultModel.getMockResultModel()

        try? realm.write {
            let mockResultLocal = mockResult.mapToLocal()
            realm.add(mockResultLocal)
        }

        // When
        let result = await sut.getUserModel(page: 3, seed: "fail")

        // Then
        XCTAssertNil(result)
    }

    @MainActor
    func testSearchUsersSuccess() async throws {
        // Given
        let mockResult = MockResultModel.getMockResultModel()
        let searchTerm = "John"

        try? realm.write {
            let mockResultLocal = mockResult.mapToLocal()
            realm.add(mockResultLocal)
        }

        // When
        let result = await sut.searchUsers(searchTerm: searchTerm)

        // Then
        XCTAssertEqual(mockResult.users.first, result.first)
    }

    @MainActor
    func testSearchUsersError() async throws {
        // Given
        let mockResult = MockResultModel.getMockResultModel()
        let searchTerm = "NotResults"

        try? realm.write {
            let mockResultLocal = mockResult.mapToLocal()
            realm.add(mockResultLocal)
        }

        // When
        let result = await sut.searchUsers(searchTerm: searchTerm)

        // Then
        XCTAssertEqual(result, [])
    }

    @MainActor
    func testDeleteUsersSuccess() async {
        // Given
        let mockResult = MockResultModel.getMockResultModel()
        let mockUserModel = MockUserModel.getMockUser()

        XCTAssertNoThrow( try realm.write {realm.add(mockResult.mapToLocal())})

        
        // When
        let result = await sut.deleteUser(userModel: mockUserModel)
        
        // Then
        XCTAssertNotNil(result)
        XCTAssertEqual(mockUserModel, result)
    }

    @MainActor
    func testDeleteUsersError() async {
        // Given
        let mockUserModel = MockUserModel.getMockUser()
        
        // When
        let result = await sut.deleteUser(userModel: mockUserModel)
        
        // Then
        XCTAssertNil(result)
    }
}
