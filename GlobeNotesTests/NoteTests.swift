//
//  GlobeNotesTests.swift
//  GlobeNotesTests
//
//  Created by magnus holm on 28/09/2018.
//  Copyright © 2018 magnus holm. All rights reserved.
//

import XCTest
@testable import GlobeNotes

class NoteTests: XCTestCase {
    
    private let noteDictionaryMock: [String: Any] = ["userName": "Magnus", "title": "Test note", "text": "Test note", "latitude": 51.5074, "longitude": -0.1278, "creationDate": 1539002336.0609941]
    
    private let homeScreenPresenterMock = HomeScreenPresenter(noteService: NoteServiceMock(), authService: AuthServiceMock(), locationManager: LocationManagerMock())
    private let homeScreenViewControllerMock = HomeScreenViewController()
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    // MARK: - Tests
    
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
    
    func test_fetch_notes_returns_correct_amount() {
        
        homeScreenViewControllerMock.presenter = homeScreenPresenterMock
        
        var mockNotes = [Note]()
        homeScreenViewControllerMock.viewDidLoad()
    
//        homeScreenViewControllerMock.fetchNotes { (notes) in
//            mockNotes = notes
//        }
        
        XCTAssert(homeScreenViewControllerMock.allNotes.count == 4)
    }
}
