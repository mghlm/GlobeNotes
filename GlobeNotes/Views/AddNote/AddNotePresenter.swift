//
//  AddNoteViewModel.swift
//  GlobeNotes
//
//  Created by magnus holm on 04/10/2018.
//  Copyright © 2018 magnus holm. All rights reserved.
//

import Foundation

protocol AddNotePresenterType {
    
    /// Saves the submitted note in the firebase database
    ///
    /// - Parameters:
    ///   - username: Username of the user submitting the note
    ///   - title: Title of the submitted note
    ///   - text: Text of the submitted note
    ///   - creationDate: The creation date of the submitted note
    ///   - completion: To be called when note is successfully submitted 
    func submitNote(with username: String, title: String, text: String, creationDate: Date, completion: @escaping () -> Void)
}

struct AddNotePresenter: AddNotePresenterType {
    
    // MARK: - Dependencies
    
    fileprivate let locationManager: LocationManagerType!
    fileprivate let noteService: NoteServiceType!
    
    // MARK: - Init
    
    init(locationManager: LocationManagerType, noteService: NoteServiceType) {
        self.locationManager = locationManager
        self.noteService = noteService
    }
    
    // MARK: - Public methods 
    
    func submitNote(with username: String, title: String, text: String, creationDate: Date, completion: @escaping () -> Void) {
        guard let latitude = locationManager.usersCurrentLocation?.coordinate.latitude else { return }
        guard let longitude = locationManager.usersCurrentLocation?.coordinate.longitude else { return }
        
        let dictionary = ["userName": username, "title": title, "text": text, "latitude": latitude, "longitude": longitude, "creationDate": Date().timeIntervalSince1970] as [String: Any]
        
        noteService.submitNote(dictionary: dictionary) {
            completion()
        }
    }
}
