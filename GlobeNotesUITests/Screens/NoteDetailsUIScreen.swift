//
//  NoteDetailsUIScreen.swift
//  GlobeNotesUITests
//
//  Created by magnus holm on 08/10/2018.
//  Copyright © 2018 magnus holm. All rights reserved.
//

import XCTest

enum NoteDetailsUIScreen {
    case noteTitle, noteContent, locationLabel, showMapButton
    
    func component(in app: XCUIApplication) -> XCUIElement {
        switch self {
        case .noteTitle:
            return app.staticTexts["noteTitle"]
        case .noteContent:
            return app.staticTexts["noteContent"]
        case .locationLabel:
            return app.staticTexts["locationLabel"]
        case .showMapButton:
            return app.buttons["showMapButton"]
        }
    }
    
    static func assertScreenExist(in app: XCUIApplication) {
        XCTAssert(NoteDetailsUIScreen.noteTitle.component(in: app).exists, "Error")
        XCTAssert(NoteDetailsUIScreen.noteContent.component(in: app).exists, "Error")
        XCTAssert(NoteDetailsUIScreen.locationLabel.component(in: app).exists, "Error")
        XCTAssert(NoteDetailsUIScreen.showMapButton.component(in: app).exists, "Error")
    }
    
    static func assertScreenDoesNotExist(in app: XCUIApplication) {
        XCTAssertFalse(NoteDetailsUIScreen.noteTitle.component(in: app).exists, "Error")
        XCTAssertFalse(NoteDetailsUIScreen.noteContent.component(in: app).exists, "Error")
        XCTAssertFalse(NoteDetailsUIScreen.locationLabel.component(in: app).exists, "Error")
        XCTAssertFalse(NoteDetailsUIScreen.showMapButton.component(in: app).exists, "Error")
    }
}
