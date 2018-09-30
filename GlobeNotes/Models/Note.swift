//
//  Note.swift
//  GlobeNotes
//
//  Created by magnus holm on 29/09/2018.
//  Copyright © 2018 magnus holm. All rights reserved.
//

import Foundation

struct Note {
    
    var id: String?
    
    let user: User?
    let title: String
    let text: String
    let latitude: Double
    let longitude: Double
    let creationDate: Date
    
    init(user: User?, dictionary: [String: Any]) {
        self.user = user
        self.title = dictionary["title"] as? String ?? ""
        self.text = dictionary["text"] as? String ?? ""
        self.latitude = dictionary["latitude"] as? Double ?? 0
        self.longitude = dictionary["longitude"] as? Double ?? 0
        self.creationDate = Date()
    }
}
