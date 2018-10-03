//
//  User.swift
//  GlobeNotes
//
//  Created by magnus holm on 28/09/2018.
//  Copyright © 2018 magnus holm. All rights reserved.
//

import Foundation

struct User {
    
    let uid: String
    let userName: String
    
    init(uid: String, dictionary: [String: Any]) {
        self.uid = uid
        self.userName = dictionary["userName"] as? String ?? ""
    }
}
