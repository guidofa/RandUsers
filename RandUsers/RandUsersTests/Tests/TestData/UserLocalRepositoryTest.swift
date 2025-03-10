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
        realm = try! Realm(configuration: realmConfiguration)

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
    func testSaveResponseSuccess() async throws {
        // Given
        let mockResponse = MockResultModel.getMockResultModel()

        // When
        await sut.saveUserModel(mockResponse)
        let responseSaved = realm.objects(ResultLocalResponse.self)

        // Then
        XCTAssertNotNil(responseSaved)
    }

    @MainActor
    func testDeleteUsers() async throws {
        let mock = MockUserModel.getMockUser()
        try! realm.write {
            realm.add(mock.mapToLocal())
        }

        let deleted = realm.object(ofType: UserLocalResponse.self, forPrimaryKey: mock.id)
        XCTAssertEqual(mock.id, deleted?.id)
    }
}
