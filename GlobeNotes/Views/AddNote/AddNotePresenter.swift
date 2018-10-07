//
//  AddNoteViewModel.swift
//  GlobeNotes
//
//  Created by magnus holm on 04/10/2018.
//  Copyright © 2018 magnus holm. All rights reserved.
//

import Foundation
import Firebase

protocol AddNotePresenterType {
    
    func submitNote(with username: String, title: String, text: String, creationDate: Date, completion: @escaping () -> Void)
}

struct AddNotePresenter: AddNotePresenterType {
    
    // MARK: - Dependencies
    
    fileprivate let locationManager: LocationManagerType!
    
    // MARK: - Init
    
    init(locationManager: LocationManagerType) {
        self.locationManager = locationManager
    }
    
    // MARK: - Public methods 
    
    func submitNote(with username: String, title: String, text: String, creationDate: Date, completion: @escaping () -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        guard let latitude = locationManager.usersCurrentLocation?.coordinate.latitude else { return }
        guard let longitude = locationManager.usersCurrentLocation?.coordinate.longitude else { return }
        
        let dbRef = Database.database().reference().child("notes").child(uid).childByAutoId()
        let values = ["userName": username, "title": title, "text": text, "latitude": latitude, "longitude": longitude, "creationDate": Date().timeIntervalSince1970] as [String: Any]
        
        dbRef.setValue(values)
        completion()
    }
}