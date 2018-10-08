//
//  GlobeNotesTests.swift
//  GlobeNotesTests
//
//  Created by magnus holm on 28/09/2018.
//  Copyright © 2018 magnus holm. All rights reserved.
//

import XCTest
@testable import GlobeNotes

class GlobeNotesTests: XCTestCase {
    
    private let noteDictionaryMock: [String: Any] = ["userName": "Magnus", "title": "Test note", "text": "Test note", "latitude": 51.5074, "longitude": -0.1278, "creationDate": 1539002336.0609941]
    private let userDictionaryMock: [String: Any] = ["uid": "123456", "userName": "Magnus"]
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    // MARK: - Note tests
    
    func test_note_json_returns_the_correct_note_object() {
        let note = Note(dictionary: noteDictionaryMock)
        
        XCTAssert(note.userName == "Magnus")
        XCTAssert(note.title == "Test note")
        XCTAssert(note.text == "Test note")
        XCTAssert(note.latitude == 51.5074)
        XCTAssert(note.longitude == -0.1278)
        
    }
    
    func test_note_location_tranformation() {
        let note = Note(dictionary: noteDictionaryMock)
        
        XCTAssert(note.location.coordinate.latitude == 51.5074)
        XCTAssert(note.location.coordinate.longitude == -0.1278)
    }
    
    // MARK: - User tests
    
    func test_user_json_returns_correct_user_object() {
        let user = User(uid: userDictionaryMock["uid"] as! String, dictionary: userDictionaryMock)
        
        XCTAssert(user.uid == "123456")
        XCTAssert(user.userName == "Magnus")
    }
}
