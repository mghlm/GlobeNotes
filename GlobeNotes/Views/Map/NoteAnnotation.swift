//
//  NoteAnnotation.swift
//  GlobeNotes
//
//  Created by magnus holm on 02/10/2018.
//  Copyright © 2018 magnus holm. All rights reserved.
//

import MapKit

final class NoteAnnotation: NSObject, MKAnnotation {
    let title: String?
    let subtitle: String?
    let coordinate: CLLocationCoordinate2D
    
    init(note: Note) {
        self.title = note.title
        self.subtitle = "Note created by \(note.userName)"
        self.coordinate = CLLocationCoordinate2D(latitude: note.latitude ?? 0, longitude: note.longitude ?? 0)
    }
}
