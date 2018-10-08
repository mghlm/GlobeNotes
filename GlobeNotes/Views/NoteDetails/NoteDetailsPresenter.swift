//
//  NoteDetailsPresenter.swift
//  GlobeNotes
//
//  Created by magnus holm on 06/10/2018.
//  Copyright © 2018 magnus holm. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation

protocol NoteDetailsPresenterType {
    func fetchCityAndCountry(from location: CLLocation, completion: @escaping (_ city: String?, _ country: String?, _ error: Error?) -> ())
    func getUid()
    
    func navigateToMapScreen(in navigationController: UINavigationController, with note: Note)
}

struct NoteDetailsPresenter: NoteDetailsPresenterType {
    
    // MARK: - Dependencies
    
    fileprivate var locationManager: LocationManagerType!
    fileprivate var authService: AuthServiceType!
    
    // MARK: - Init
    
    init(locationManager: LocationManagerType, authService: AuthServiceType) {
        self.locationManager = locationManager
        self.authService = authService
    }
    
    // MARK: - Public methods
    
    func fetchCityAndCountry(from location: CLLocation, completion: @escaping (_ city: String?, _ country: String?, _ error: Error?) -> ()) {
        CLGeocoder().reverseGeocodeLocation(location) { (placemarks, error) in
            completion(placemarks?.first?.locality, placemarks?.first?.country, error)
        }
    }
    
    func getUid() {
//        return authService.
    }
}

// Navigation

extension NoteDetailsPresenter {
    func navigateToMapScreen(in navigationController: UINavigationController, with note: Note) {
        var notes = [Note]()
        notes.append(note)
        let mapScreenPresenter = MapScreenPresenter(locationManager: locationManager, notes: notes)
        let mapScreenViewController = MapScreenViewController()
        mapScreenViewController.arrivedFromDetails = true
        mapScreenViewController.presenter = mapScreenPresenter
        navigationController.pushViewController(mapScreenViewController, animated: true)
    }
}
