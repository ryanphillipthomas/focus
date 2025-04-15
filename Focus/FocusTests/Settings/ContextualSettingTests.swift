//
//  ContextualSettingTests.swift
//  Focus
//
//  Created by Ryan Thomas on 4/15/25.
//


import XCTest
@testable import Focus

final class ContextualSettingTests: XCTestCase {
    func testContextualSettingCallsAction() {
        // Arrange
        let expectation = XCTestExpectation(description: "Action closure should be called")

        let setting = ContextualSetting(
            title: "Test Title",
            systemImage: "gear",
            action: {
                expectation.fulfill()
            }
        )

        // Act
        setting.action()

        // Assert
        wait(for: [expectation], timeout: 1.0)
    }
}
