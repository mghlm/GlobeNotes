//
//  FirebaseShared.swift
//  GlobeNotes
//
//  Created by magnus holm on 02/10/2018.
//  Copyright © 2018 magnus holm. All rights reserved.
//

import Foundation
import Firebase

extension Database {
    static func fetchUserWithUid(uid: String, completion: @escaping (User) -> ()) {
        Database.database().reference().child("users").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
            guard let userDictionary = snapshot.value as? [String: Any] else { return }
            let user = User(uid: uid, dictionary: userDictionary)
            completion(user)
        }) { (error) in
            print("Failed to fetch user:", error)
        }
    }
    
    static func fetchNotes(completion: @escaping ([Note]) -> ()) {
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
}
