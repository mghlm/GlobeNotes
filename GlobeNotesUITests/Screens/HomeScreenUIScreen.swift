//
//  HomeScreenUIScreen.swift
//  GlobeNotesUITests
//
//  Created by magnus holm on 08/10/2018.
//  Copyright © 2018 magnus holm. All rights reserved.
//

import XCTest

enum HomeScreenUIScreen {
    case addNoteButton, settingsButton, mapButton, notesTableView
    
    func component(in app: XCUIApplication) -> XCUIElement {
        switch self {
        case .addNoteButton:
            return app.buttons["addNoteButton"]
        case .settingsButton:
            return app.buttons["settingsButton"]
        case .mapButton:
            return app.buttons["mapButton"]
        case .notesTableView:
            return app.otherElements["notesTableView"]
        }
    }
    
    static func assertScreenExist(in app: XCUIApplication) {
        XCTAssert(HomeScreenUIScreen.addNoteButton.component(in: app).exists, "Error")
        XCTAssert(HomeScreenUIScreen.settingsButton.component(in: app).exists, "Error")
        XCTAssert(HomeScreenUIScreen.mapButton.component(in: app).exists, "Error")
        XCTAssert(HomeScreenUIScreen.notesTableView.component(in: app).exists, "Error")
    }
    
    static func assertScreenDoesNotExist(in app: XCUIApplication) {
        XCTAssertFalse(HomeScreenUIScreen.addNoteButton.component(in: app).exists, "Error")
        XCTAssertFalse(HomeScreenUIScreen.settingsButton.component(in: app).exists, "Error")
        XCTAssertFalse(HomeScreenUIScreen.mapButton.component(in: app).exists, "Error")
        XCTAssertFalse(HomeScreenUIScreen.notesTableView.component(in: app).exists, "Error")
    }
}
