//
//  MapScreenViewController.swift
//  GlobeNotes
//
//  Created by magnus holm on 01/10/2018.
//  Copyright © 2018 magnus holm. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

final class MapScreenViewController: UIViewController {
    
    // MARK: - Dependencies
    
    var presenter: MapScreenPresenterType!
    
    // MARK: - Private properties
    
    fileprivate var mapView: MKMapView!
    
    // MARK: - Public properties
    
    var arrivedFromDetails = false
    
    // MARK: - Constants
    
    let regionLatitudeSpan = 0.15
    let regionLongitudeSpan = 0.15
    
    // MARK: - ViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    // MARK: - Private methods
    
    fileprivate func setupUI() {
        navigationItem.largeTitleDisplayMode = .never
        
        setupMapView()
        setupConstraints()
    }
    
    fileprivate func setupConstraints() {
        mapView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
    }
    
    fileprivate func setupMapView() {
        mapView = MKMapView()
        mapView.delegate = self
        presenter.addAnnotations(to: mapView)
        mapView.showsUserLocation = true
        if presenter.isLocationAuthorized(), !arrivedFromDetails {
            zoomToUsersCurrentLocation(latitudeSpan: regionLatitudeSpan, longitudeSpan: regionLongitudeSpan)
        }
        if arrivedFromDetails {
            zoomToNoteLocation(latitudeSpan: regionLatitudeSpan, longitudeSpan: regionLongitudeSpan)
        }
        view.addSubview(mapView)
    }
    
    /// Zooms to specified region with user's current location as center
    fileprivate func zoomToUsersCurrentLocation(latitudeSpan: Double, longitudeSpan: Double) {
        if let region = presenter.getRegionForUsersLocation(latitudeSpan: latitudeSpan, longitudeSpan: longitudeSpan) {
            mapView.setRegion(region, animated: true)
        }
    }
    
    fileprivate func zoomToNoteLocation(latitudeSpan: Double, longitudeSpan: Double) {
        if let region = presenter.getRegionForNote(latitudeSpan: latitudeSpan, longitudeSpan: longitudeSpan) {
            mapView.setRegion(region, animated: true)
        }
    }
}

extension MapScreenViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation { return nil }
        
        let contentView = UIView()
        contentView.backgroundColor = UIColor.rgb(red: 242, green: 242, blue: 242)
        contentView.layer.cornerRadius = 6
        contentView.clipsToBounds = true
        
        let contentLabel = UILabel()
        contentLabel.numberOfLines = 0
        contentLabel.font = UIFont.systemFont(ofSize: 12)
        let text = (annotation as! NoteAnnotation).text
        let author = (annotation as! NoteAnnotation).subtitle
        contentLabel.text = "\(text ?? "") \n\n\(author ?? "unkown")"
        
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "callOutViewId") as? MKMarkerAnnotationView
        let rightButton = UIButton(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: 30, height: 30)))
        rightButton.setTitle("✏️🌎", for: .normal)
        if annotationView == nil {
            annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: "callOutViewId")
            annotationView?.addSubview(contentView)
            annotationView?.detailCalloutAccessoryView = contentLabel
            annotationView?.canShowCallout = true
            annotationView?.rightCalloutAccessoryView = rightButton
        } else {
            annotationView?.annotation = annotation
        }
        
        return annotationView
    }
    
    
}






































