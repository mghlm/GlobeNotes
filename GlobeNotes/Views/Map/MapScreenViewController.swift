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
    
    // MARK: - Public properties
    
    var notes: [Note]!
    
    // MARK: - Private properties
    
    fileprivate var mapView: MKMapView!
    
    // MARK: - ViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.fetchNotes { (notes) in
            self.notes = notes
            self.addAnnotations()
        }
        
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
        mapView.showsUserLocation = true
        if viewModel.isLocationAuthorized() {
            zoomToUsersCurrentLocation()
        }
        view.addSubview(mapView)
    }
    
    fileprivate func zoomToUsersCurrentLocation() {
        if let region = viewModel.getRegion(latitudeSpan: 0.15, longitudeSpan: 0.15) {
            mapView.setRegion(region, animated: true)
        }
    }
    
    fileprivate func addAnnotations() {
        for note in notes {
            let annotation = NoteAnnotation(note: note)
            mapView.addAnnotation(annotation)
        }
    }
}






































