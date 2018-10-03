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
    
    let userName: String?
    let title: String
    let text: String
    let imageUrl: String?
    let latitude: Double?
    let longitude: Double?
    let creationDate: Date
    
    init(dictionary: [String: Any]) {
        self.userName = dictionary["userName"] as? String
        self.title = dictionary["title"] as? String ?? ""
        self.text = dictionary["text"] as? String ?? ""
        self.imageUrl = dictionary["imageUrl"] as? String 
        self.latitude = dictionary["latitude"] as? Double
        self.longitude = dictionary["longitude"] as? Double
        self.creationDate = Date()
    }
}
