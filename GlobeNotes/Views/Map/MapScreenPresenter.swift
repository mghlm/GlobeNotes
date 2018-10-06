//
//  MapScreenViewModel.swift
//  GlobeNotes
//
//  Created by magnus holm on 04/10/2018.
//  Copyright © 2018 magnus holm. All rights reserved.
//

import Foundation
import MapKit

protocol MapScreenPresenterType {
    
    /// Gets a region to show on map
    ///
    /// - Parameters:
    ///   - latitudeSpan: The specified span of the latitude
    ///   - longitudeSpan: The specified span of longitude
    /// - Returns: A region to use for map
    func getRegion(latitudeSpan: Double, longitudeSpan: Double) -> MKCoordinateRegion?
    
    /// To check if user has authorized location
    ///
    /// - Returns: True or false
    func isLocationAuthorized() -> Bool
    
    /// To get the current location of the user
    ///
    /// - Returns: User's location as CLLocation coordinate object
    func getUsersLocationCoordinates() -> CLLocationCoordinate2D?
    
    /// Adds annotations to the mapView based on the fetched notes
    ///
    /// - Parameter notes: All the notes currently in the database
    func addAnnotations(to mapView: MKMapView)
}

struct MapScreenPresenter: MapScreenPresenterType {
    
    // MARK: - Dependencies
    
    private var locationManager: LocationManagerType!
    private var notes: [Note]!
    
    // MARK: - Init
    
    init(locationManager: LocationManagerType, notes: [Note]) {
        self.locationManager = locationManager
        self.notes = notes
    }
    
    // MARK: - Public methods
    
    func getRegion(latitudeSpan: Double, longitudeSpan: Double) -> MKCoordinateRegion? {
        if let userLocation = getUsersLocationCoordinates() {
            let location = CLLocationCoordinate2D(latitude: userLocation.latitude, longitude: userLocation.longitude)
            let span = MKCoordinateSpan(latitudeDelta: latitudeSpan, longitudeDelta: longitudeSpan)
            let region = MKCoordinateRegion(center: location, span: span)
            
            return region
        }
        return nil
    }
    
    func isLocationAuthorized() -> Bool {
        return locationManager.isLocationAuthorized()
    }
    
    func getUsersLocationCoordinates() -> CLLocationCoordinate2D? {
        return locationManager.usersCurrentLocation?.coordinate
    }
    
    func addAnnotations(to mapView: MKMapView) {
        for note in notes {
            let annotation = NoteAnnotation(note: note)
            mapView.addAnnotation(annotation)
        }
    }
}
