//
//  GlobeNotesUITests.swift
//  GlobeNotesUITests
//
//  Created by magnus holm on 28/09/2018.
//  Copyright © 2018 magnus holm. All rights reserved.
//

import XCTest

class GlobeNotesUITests: XCTestCase {
    
    private var app = XCUIApplication()
        
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func test_sign_in_user() {
//        let email = "Magnus@gmail.com"
//        let password = "magnus123"
        
        app.launch()
        
        
        
        SignInUIScreen.assertScreenExist(in: app)
    }
    
    func test_user_can_navigate_to_sign_up() {
        
    }
    
}
