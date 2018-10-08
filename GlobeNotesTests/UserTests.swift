//
//  UserTests.swift
//  GlobeNotesTests
//
//  Created by magnus holm on 08/10/2018.
//  Copyright © 2018 magnus holm. All rights reserved.
//

import XCTest
@testable import GlobeNotes

class UserTests: XCTestCase {
    
    private let userDictionaryMock: [String: Any] = ["uid": "123456", "userName": "Magnus"]
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    // MARK: - Tests
    
    func test_user_json_returns_correct_user_object() {
        let user = User(uid: userDictionaryMock["uid"] as! String, dictionary: userDictionaryMock)
        
        XCTAssert(user.uid == "123456")
        XCTAssert(user.userName == "Magnus")
    }
}
