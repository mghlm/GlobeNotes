//
//  Mocks.swift
//  GlobeNotesTests
//
//  Created by magnus holm on 08/10/2018.
//  Copyright © 2018 magnus holm. All rights reserved.
//

import Foundation
import CoreLocation
@testable import GlobeNotes

// MARK: - NoteService mock

class NoteServiceMock: NoteServiceType {
    func submitNote(dictionary: [String : Any], completion: @escaping () -> Void) {}
    
    
    let firstNoteDictMock: [String: Any] = ["userName": "Magnus", "title": "Test note 1", "text": "Test note 1", "latitude": 51.5074, "longitude": -0.1278, "creationDate": 1539002336.0609941]
    let secondNoteDictMock: [String: Any] = ["userName": "Bob", "title": "Test note 2", "text": "Test note 2", "latitude": 51.5074, "longitude": -0.1278, "creationDate": 1539002336.0609941]
    let thirdNoteDictMock: [String: Any] = ["userName": "Joe", "title": "Test note 3", "text": "Test note 3", "latitude": 51.5074, "longitude": -0.1278, "creationDate": 1539002336.0609941]
    let fourthNoteDictMock: [String: Any] = ["userName": "Dan", "title": "Test note 4", "text": "Test note 4", "latitude": 51.5074, "longitude": -0.1278, "creationDate": 1539002336.0609941]
    
    func fetchNotes(completion: @escaping ([Note]) -> ()) {
        let firstNote = Note(dictionary: firstNoteDictMock)
        let secondNote = Note(dictionary: secondNoteDictMock)
        let thirdNote = Note(dictionary: thirdNoteDictMock)
        let fourthNote = Note(dictionary: fourthNoteDictMock)
        
        var noteArray = [Note]()
        noteArray.append(firstNote)
        noteArray.append(secondNote)
        noteArray.append(thirdNote)
        noteArray.append(fourthNote)
        
        completion(noteArray)
    }
    
}

// MARK: - AuthService mock

class AuthServiceMock: AuthServiceType {
    
    let userDictionaryMock: [String: Any] = ["userName": "Magnus"]
    
    func fetchUser(completion: @escaping (User) -> ()) {
        completion(User(uid: "123456", dictionary: userDictionaryMock))
    }
    
    func isUserSignedIn() -> Bool {
        return true 
    }
    
    func signUserOut(completion: @escaping () -> ()) {}
    
    func signUpNewUser(email: String, username: String, password: String, completion: @escaping () -> Void) {}
    
    func signInUser(email: String, password: String, completion: @escaping () -> Void) {}
}

// MARK: - LocationManager mock

class LocationManagerMock: LocationManagerType {
    var usersCurrentLocation: CLLocation?
    
    var authorizationStatus: CLAuthorizationStatus! = .authorizedWhenInUse
    
    func isLocationAuthorized() -> Bool {
        return true
    }
    
    func startUpdatingLocation() {}
    
    func stopUpdatingLocation() {}
    
    func requestWhenInUseAuthorization() {}
    
}
