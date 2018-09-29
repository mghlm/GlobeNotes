//
//  Note.swift
//  GlobeNotes
//
//  Created by magnus holm on 29/09/2018.
//  Copyright © 2018 magnus holm. All rights reserved.
//

import Foundation

struct Note {
    
    let user: User
    
    let id: String?
    let title: String
    let text: String
    let latitude: Double
    let longitude: Double
    let creationDate: Date
}
