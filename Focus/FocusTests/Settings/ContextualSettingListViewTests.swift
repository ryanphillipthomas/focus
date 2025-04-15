//
//  ContextualSettingListViewTests.swift
//  Focus
//
//  Created by Ryan Thomas on 4/15/25.
//


import XCTest
import ViewInspector
@testable import Focus

final class ContextualSettingListViewTests: XCTestCase {
    func testButtonTapsTriggerAction() throws {
        var didCallAction = false

        let options = [
            ContextualSetting(
                title: "Test Option",
                systemImage: "gear",
                action: { didCallAction = true }
            )
        ]

        let sut = ContextualSettingListView(title: "Test Settings", options: options)

        let button = try sut.inspect().find(ViewType.Button.self)
        try button.tap()

        XCTAssertTrue(didCallAction, "Button action should be triggered on tap.")
    }
}
