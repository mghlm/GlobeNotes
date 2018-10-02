//
//  NoteAnnotation.swift
//  GlobeNotes
//
//  Created by magnus holm on 02/10/2018.
//  Copyright © 2018 magnus holm. All rights reserved.
//

import MapKit

class NoteAnnotation: NSObject, MKAnnotation {
    let title: String?
    let subtitle: String?
    let coordinate: CLLocationCoordinate2D
    
    init(title: String?, subtitle: String?, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.subtitle = subtitle
        self.coordinate = coordinate
    }
}
