//
//  Note.swift
//  GlobeNotes
//
//  Created by magnus holm on 29/09/2018.
//  Copyright © 2018 magnus holm. All rights reserved.
//

import Foundation
import CoreLocation

struct Note {
    
    var id: String?
    var uid: String?
    
    let userName: String
    let title: String
    let text: String
//    let imageUrl: String?
    let latitude: Double?
    let longitude: Double?
    let creationDate: Date
    var location: CLLocation {
        return CLLocation(latitude: latitude ?? 0, longitude: longitude ?? 0)
    }
    
    
    init(dictionary: [String: Any]) {
        self.userName = dictionary["userName"] as! String
        self.title = dictionary["title"] as? String ?? ""
        self.text = dictionary["text"] as? String ?? ""
//        self.imageUrl = dictionary["imageUrl"] as? String
        self.latitude = dictionary["latitude"] as? Double
        self.longitude = dictionary["longitude"] as? Double
        
        let secondsFrom1970 = dictionary["creationDate"] as? Double ?? 0
        self.creationDate = Date(timeIntervalSince1970: secondsFrom1970)
    }
    
    /// Method used to calculate the distance from a given location to where the note was submitted 
    func distance(to location: CLLocation) -> CLLocationDistance {
        return location.distance(from: self.location)
    }
}
