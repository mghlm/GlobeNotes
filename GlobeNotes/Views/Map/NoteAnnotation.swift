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
    let text: String?
    let subtitle: String?
    let coordinate: CLLocationCoordinate2D
    
    init(note: Note) {
        self.title = note.title
        self.text = note.text
        self.subtitle = "Note created by \(note.userName)"
        self.coordinate = CLLocationCoordinate2D(latitude: note.latitude ?? 0, longitude: note.longitude ?? 0)
    }
}

//final class NoteAnnotationView: MKAnnotationView {
//    
//    override var annotation: MKAnnotation? {
//        willSet {
//            guard let note = newValue as? NoteAnnotation else { return }
//            
//            canShowCallout = true
//            calloutOffset = CGPoint(x: -5, y: 5)
//            let rightButton = UIButton(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: 30, height: 30)))
//            rightButton.setTitle("✏️🌎", for: .normal)
//            rightCalloutAccessoryView = rightButton
//            
//            let textLabel = UILabel()
//            textLabel.text = "\(note.text ?? "")\n\n\(note.subtitle ?? "")"
//            textLabel.numberOfLines = 0
//            textLabel.font = UIFont.systemFont(ofSize: 12)
//            detailCalloutAccessoryView = textLabel
//        }
//    }
//}
