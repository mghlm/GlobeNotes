//
//  MapScreenViewModel.swift
//  GlobeNotes
//
//  Created by magnus holm on 04/10/2018.
//  Copyright © 2018 magnus holm. All rights reserved.
//

import Foundation
import MapKit

protocol MapScreenViewModelType {
    
    func getRegion(latitudeSpan: Double, longitudeSpan: Double) -> MKCoordinateRegion?
    func isLocationAuthorized() -> Bool
    func getUsersLocationCoordinates() -> CLLocationCoordinate2D?
    func fetchNotes(completion: @escaping ([Note]) -> ())
//    func fetchNotes() -> [Note]
}

struct MapScreenViewModel: MapScreenViewModelType {
    
    // MARK: - Dependencies
    
    private var locationManager: LocationManagerType!
    private var noteService: NoteServiceType!
    
    // MARK: - Init
    
    init(locationManager: LocationManagerType, noteService: NoteServiceType) {
        self.locationManager = locationManager
        self.noteService = noteService
    }
    
    // MARK: - Public methods
    
    func getRegion(latitudeSpan: Double, longitudeSpan: Double) -> MKCoordinateRegion? {
        if let userLocation = getUsersLocationCoordinates() {
            let location = CLLocationCoordinate2D(latitude: userLocation.latitude, longitude: userLocation.longitude)
            let span = MKCoordinateSpan(latitudeDelta: 0.15, longitudeDelta: 0.15)
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
    
    func fetchNotes(completion: @escaping ([Note]) -> ()) {
        noteService.fetchNotes { (notes) in
            completion(notes)
        }
    }
    
    
//    func fetchNotes() -> [Note] {
//        var notes = [Note]()
//        noteService.fetchNotes { (fetchedNotes) in
//            notes = fetchedNotes
//        }
//        return notes
//    }
}
