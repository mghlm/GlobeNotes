    //
    //  SignUpUIScreen.swift
    //  GlobeNotesUITests
    //
    //  Created by magnus holm on 08/10/2018.
    //  Copyright © 2018 magnus holm. All rights reserved.
    //
    
    import XCTest
    
    enum SignUpUIScreen {
        case emailTextField, usernameTextField, passwordTextField, submitButton, alreadyHaveAccountButton
        
        func component(in app: XCUIApplication) -> XCUIElement {
            switch self {
            case .emailTextField:
                return app.textFields["emailTextField"]
            case .usernameTextField:
                return app.textFields["usernameTextField"]
            case .passwordTextField:
                return app.textFields["passwordTextField"]
            case .submitButton:
                return app.buttons["submitButton"]
            case .alreadyHaveAccountButton:
                return app.buttons["alreadyHaveAccountButton"]
            }
        }
        
        static func assertScreenExist(in app: XCUIApplication) {
            XCTAssert(SignUpUIScreen.emailTextField.component(in: app).exists, "Error")
            XCTAssert(SignUpUIScreen.usernameTextField.component(in: app).exists, "Error")
            XCTAssert(SignUpUIScreen.passwordTextField.component(in: app).exists, "Error")
            XCTAssert(SignUpUIScreen.submitButton.component(in: app).exists, "Error")
            XCTAssert(SignUpUIScreen.alreadyHaveAccountButton.component(in: app).exists, "Error")
        }
        
        static func assertScreenDoesNotExist(in app: XCUIApplication) {
            XCTAssertFalse(SignUpUIScreen.emailTextField.component(in: app).exists, "Error")
            XCTAssertFalse(SignUpUIScreen.usernameTextField.component(in: app).exists, "Error")
            XCTAssertFalse(SignUpUIScreen.passwordTextField.component(in: app).exists, "Error")
            XCTAssertFalse(SignUpUIScreen.submitButton.component(in: app).exists, "Error")
            XCTAssertFalse(SignUpUIScreen.alreadyHaveAccountButton.component(in: app).exists, "Error")
        }
    }
