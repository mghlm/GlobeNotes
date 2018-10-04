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
    
    var viewModel: MapScreenViewModelType!
    
    // MARK: - Private properties
    
    fileprivate var mapView: MKMapView!
    
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
        viewModel.fetchNotes { (notes) in
            self.addAnnotations(with: notes)
        }
        mapView.showsUserLocation = true
        if viewModel.isLocationAuthorized() {
            zoomToUsersCurrentLocation(latitudeSpan: regionLatitudeSpan, longitudeSpan: regionLongitudeSpan)
        }
        view.addSubview(mapView)
    }
    
    /// Zooms to specified region with user's current location as center
    fileprivate func zoomToUsersCurrentLocation(latitudeSpan: Double, longitudeSpan: Double) {
        if let region = viewModel.getRegion(latitudeSpan: latitudeSpan, longitudeSpan: longitudeSpan) {
            mapView.setRegion(region, animated: true)
        }
    }
    
    /// Adds annotations to the mapView based on the fetched notes
    ///
    /// - Parameter notes: All the notes currently in the database
    fileprivate func addAnnotations(with notes: [Note]) {
        for note in notes {
            let annotation = NoteAnnotation(note: note)
            mapView.addAnnotation(annotation)
        }
    }
}






































