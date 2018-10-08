//
//  SignInUIScreen.swift
//  GlobeNotesUITests
//
//  Created by magnus holm on 08/10/2018.
//  Copyright © 2018 magnus holm. All rights reserved.
//

import XCTest

enum SignInUIScreen {
    case emailTextField, passwordTextField, submitButton, alreadyHaveAccountButton
    
    func component(in app: XCUIApplication) -> XCUIElement {
        switch self {
        case .emailTextField:
            return app.textFields["emailTextField"]
        case .passwordTextField:
            return app.textFields["passwordTextField"]
        case .submitButton:
            return app.buttons["submitButton"]
        case .alreadyHaveAccountButton:
            return app.buttons["alreadyHaveAccountButton"]
        }
    }
    
    static func assertScreenExist(in app: XCUIApplication) {
        XCTAssert(SignInUIScreen.emailTextField.component(in: app).exists, "Error")
        XCTAssert(SignInUIScreen.passwordTextField.component(in: app).exists, "Error")
        XCTAssert(SignInUIScreen.submitButton.component(in: app).exists, "Error")
        XCTAssert(SignInUIScreen.alreadyHaveAccountButton.component(in: app).exists, "Error")
    }
    
    static func assertScreenDoesNotExist(in app: XCUIApplication) {
        XCTAssertFalse(SignInUIScreen.emailTextField.component(in: app).exists, "Error")
        XCTAssertFalse(SignInUIScreen.passwordTextField.component(in: app).exists, "Error")
        XCTAssertFalse(SignInUIScreen.submitButton.component(in: app).exists, "Error")
        XCTAssertFalse(SignInUIScreen.alreadyHaveAccountButton.component(in: app).exists, "Error")
    }
}
