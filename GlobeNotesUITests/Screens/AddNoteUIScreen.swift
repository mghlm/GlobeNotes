//
//  AddNoteUIScreen.swift
//  GlobeNotesUITests
//
//  Created by magnus holm on 08/10/2018.
//  Copyright © 2018 magnus holm. All rights reserved.
//

import XCTest

enum AddNoteUIScreen {
    case titleTextField, contentTextField, submitButton
    
    func component(in app: XCUIApplication) -> XCUIElement {
        switch self {
        case .titleTextField:
            return app.textFields["titleTextField"]
        case .contentTextField:
            return app.textViews["contentTextField"]
        case .submitButton:
            return app.buttons["submitButton"]
        }
    }
    
    static func assertScreenExist(in app: XCUIApplication) {
        XCTAssert(AddNoteUIScreen.titleTextField.component(in: app).exists, "Error")
        XCTAssert(AddNoteUIScreen.contentTextField.component(in: app).exists, "Error")
        XCTAssert(AddNoteUIScreen.submitButton.component(in: app).exists, "Error")
    }
    
    static func assertScreenDoesNotExist(in app: XCUIApplication) {
        XCTAssertFalse(AddNoteUIScreen.titleTextField.component(in: app).exists, "Error")
        XCTAssertFalse(AddNoteUIScreen.contentTextField.component(in: app).exists, "Error")
        XCTAssertFalse(AddNoteUIScreen.submitButton.component(in: app).exists, "Error")
    }
}
