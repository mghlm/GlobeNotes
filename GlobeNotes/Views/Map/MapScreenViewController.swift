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
    
    // MARK: - Private properties
    
    fileprivate var mapView: MKMapView!
    
    // MARK: - Public properties
    
    var notes: [Note]!
    
    // MARK: - Dependencies
    
    var locationManager: LocationManagerType!
    
    // MARK: - ViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.largeTitleDisplayMode = .never
        
        setupUI()
    }
    
    // MARK: - Private methods
    
    fileprivate func setupUI() {
        setupMapView()
        zoomToUsersCurrentLocation()
        setupConstraints()
    }
    
    fileprivate func setupConstraints() {
        mapView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
    }
    
    fileprivate func setupMapView() {
        mapView = MKMapView()
        mapView.showsUserLocation = true
        addAnnotations()
        view.addSubview(mapView)
    }
    
    fileprivate func zoomToUsersCurrentLocation() {
        let usersCoordinateLocation = locationManager.usersCurrentLocation.coordinate
        let location = CLLocationCoordinate2D(latitude: usersCoordinateLocation.latitude, longitude: usersCoordinateLocation.longitude)
        let span = MKCoordinateSpan(latitudeDelta: 0.15, longitudeDelta: 0.15)
        let region = MKCoordinateRegion(center: location, span: span)
        mapView.setRegion(region, animated: true)
    }
    
    fileprivate func addAnnotations() {
        for note in notes {
            let annotation = NoteAnnotation(note: note)
            mapView.addAnnotation(annotation)
        }
    }
}






































