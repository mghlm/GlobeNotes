//
//  NoteService.swift
//  GlobeNotes
//
//  Created by magnus holm on 04/10/2018.
//  Copyright © 2018 magnus holm. All rights reserved.
//

import Foundation
import Firebase

protocol NoteServiceType {
    
    /// Fetches all notes currently saved in database
    ///
    /// - Parameter completion: To be used with array of all notes when all notes are successfully fetched
    func fetchNotes(completion: @escaping ([Note]) -> ())
    
    /// Saves a new note in the firebase database
    ///
    /// - Parameters:
    ///   - dictionary: Dictionary with the values of the note
    ///   - completion: To be called when the note is successfully saved 
    func submitNote(dictionary: [String: Any], completion: @escaping () -> Void)
}

struct NoteService: NoteServiceType {
    
    func fetchNotes(completion: @escaping ([Note]) -> ()) {
        var notes = [Note]()
        Database.database().reference().child("notes").observeSingleEvent(of: .value, with: { (snapshot) in
            guard let dictionaries = snapshot.value as? [String: Any] else { return }
            
            dictionaries.forEach({ (key, value) in
                guard let userIdDictionaries = value as? [String: Any] else { return }
                let userId = key
                
                userIdDictionaries.forEach({ (key, value) in
                    guard let noteDictionary = value as? [String: Any] else { return }
                    
                    var note = Note(dictionary: noteDictionary)
                    note.uid = userId
                    note.id = key
                    notes.append(note)
                    completion(notes)
                })
            })
        }) { (error) in
            print("Failed to fetch notes:", error)
        }
    }
    
    func submitNote(dictionary: [String: Any], completion: @escaping () -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let dbRef = Database.database().reference().child("notes").child(uid).childByAutoId()
        
        dbRef.setValue(dictionary)
        completion()
    }
}
