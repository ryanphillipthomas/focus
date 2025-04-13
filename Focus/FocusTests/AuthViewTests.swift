//
//  AuthViewTests.swift
//  Focus
//
//  Created by Ryan Thomas on 4/10/25.
//


import XCTest
import SwiftUI
import ViewInspector
@testable import Focus

final class AuthViewTests: XCTestCase {

    func testInitialViewState() throws {
        let mockAuth = MockAuthViewModel()
        let sut = AuthView(auth: mockAuth)

        let emailLabel = try sut.inspect().vStack().textField(0).labelView().text().string()
        XCTAssertEqual(emailLabel, "Email")

        let passwordLabel = try sut.inspect().vStack().secureField(0).labelView().text().string()
        XCTAssertEqual(passwordLabel, "Password")
    }


    func testToggleLoginSignUpText() throws {
        let mockAuth = MockAuthViewModel()
        var sut = AuthView(auth: mockAuth)

        let toggleButton = try sut.inspect().vStack().button(1)
        try toggleButton.tap()
        let updatedLabel = try sut.inspect().vStack().button(0).labelView().text().string()
        XCTAssertEqual(updatedLabel, "Sign Up")
    }

    func testLoginCallsSignIn() async throws {
        let mockAuth = MockAuthViewModel()
        var sut = AuthView(auth: mockAuth)

        // Simulate user input for email and password fields
        let emailField = try sut.inspect().vStack().textField(0)
        try emailField.setInput("test@example.com")

        let passwordField = try sut.inspect().vStack().secureField(0)
        try passwordField.setInput("password")

        // Tap the Login button (index 0)
        let loginButton = try sut.inspect().vStack().button(0)
        try loginButton.tap()

        // Let the background Task run
        try await Task.sleep(nanoseconds: 100_000_000)

        // Assert correct method was called
        XCTAssertTrue(mockAuth.signInCalled)
        XCTAssertFalse(mockAuth.signUpCalled)
    }


    func testSignUpCallsSignUp() async throws {
        let mockAuth = MockAuthViewModel()
        var sut = AuthView(auth: mockAuth)

        // Flip to Sign Up mode
        let toggleButton = try sut.inspect().vStack().button(1)
        try toggleButton.tap() // toggles isLogin to false

        // Simulate user typing
        let emailField = try sut.inspect().vStack().textField(0)
        try emailField.setInput("test@example.com")

        let passwordField = try sut.inspect().vStack().secureField(0)
        try passwordField.setInput("password123")

        // Tap "Sign Up"
        let actionButton = try sut.inspect().vStack().button(0)
        try actionButton.tap()

        XCTAssertTrue(mockAuth.signUpCalled)
        XCTAssertFalse(mockAuth.signInCalled)
    }



    func testErrorMessageIsDisplayed() throws {
        let mockAuth = MockAuthViewModel()
        mockAuth.errorMessage = "Invalid credentials"
        let sut = AuthView(auth: mockAuth)

        let errorText = try sut.inspect().vStack().find(ViewType.Text.self, where: {
            try $0.attributes().foregroundColor() == .red
        }).string()

        XCTAssertEqual(errorText, "Invalid credentials")
    }
}
