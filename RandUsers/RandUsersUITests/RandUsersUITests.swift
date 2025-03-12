//
//  RandUsersUITests.swift
//  RandUsersUITests
//
//  Created by Guido Fabio on 6/3/25.
//

import XCTest

final class RandUsersUITests: XCTestCase {

    var app: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }

    override func tearDownWithError() throws {
        app = nil
    }

    @MainActor
    func testUITesting_tappingAUser_DetailOpen() throws {
        // Given
        let usersList = app.scrollViews["UsersList"]
        let userView = usersList.children(matching: .other).element(boundBy: 1).children(matching: .other).element

        // When
        userView.tap()

        // Then
        let userDetailNavBar = app.navigationBars["Random User"]
        XCTAssertTrue(userDetailNavBar.waitForExistence(timeout: 5))
    }

    @MainActor
    func testUITesting_whenCrossButtonInDetailIsTapped_viewIsDismissed() throws {
        // Given
        let usersList = app.scrollViews["UsersList"]
        let userDetailNavBar = app.navigationBars["Random User"]
        let userView = usersList.children(matching: .other).element(boundBy: 1).children(matching: .other).element

        // When
        userView.tap()
        userDetailNavBar.buttons["CloseDetailButton"].tap()

        // Then
        XCTAssertFalse(userDetailNavBar.exists)
    }

    @MainActor
    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}
