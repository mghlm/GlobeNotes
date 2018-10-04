//
//  NoteViewModel.swift
//  GlobeNotes
//
//  Created by magnus holm on 04/10/2018.
//  Copyright © 2018 magnus holm. All rights reserved.
//

import Foundation

struct NoteViewModel {
    
    let title: String
    let author: String
    let location: String
    let date: Date
    
    init(title: String, author: String, location: String, date: Date) {
        self.title = title
        self.author = author
        self.location = location
        self.date = date
    }
}
