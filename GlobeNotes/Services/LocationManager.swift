//
//  LocationManager.swift
//  GlobeNotes
//
//  Created by magnus holm on 01/10/2018.
//  Copyright © 2018 magnus holm. All rights reserved.
//

import Foundation
import CoreLocation
import UIKit

protocol LocationManagerType {
    
    var usersCurrentLocation: CLLocation! { get }
    
    func startUpdatingLocation()
    
    func stopUpdatingLocation()
    
    func requestWhenInUseAuthorization()
}

class LocationManager: NSObject, LocationManagerType {
    
    // MARK: - Private propreties
    
    fileprivate let locationManager: CLLocationManager = {
        let lm = CLLocationManager()
        lm.desiredAccuracy = kCLLocationAccuracyBest
        return lm
    }()
    
    // MARK: - Public properties
    
    var usersCurrentLocation: CLLocation!
    var authorizationStatus: CLAuthorizationStatus!
    
    // MARK: - Initialization
    
    override init() {
        super.init()
        
        authorizationStatus = CLLocationManager.authorizationStatus()
        locationManager.delegate = self
    }
    
    // MARK: - Public methods
    
    func startUpdatingLocation() {
        locationManager.startUpdatingLocation()
    }
    
    func stopUpdatingLocation() {
        locationManager.stopUpdatingLocation()
    }
    
    func requestWhenInUseAuthorization() {
        locationManager.requestWhenInUseAuthorization()
    }
}

extension LocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard !locations.isEmpty else { return }
        usersCurrentLocation = locations.first
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to fetch location:", error)
    }
}
















