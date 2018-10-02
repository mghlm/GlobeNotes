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
    
    /// Fetches the current location of the user
    var usersCurrentLocation: CLLocation! { get }
    
    /// Starts updating user's live location
    func startUpdatingLocation()
    
    /// Ends updating user's live location
    func stopUpdatingLocation()
    
    /// Presents an alert for the user to choose to accept their location to be shared with the app
    func requestWhenInUseAuthorization()
    
    /// Checks if user has given permission for app to use location either always or when in use
    ///
    /// - Returns: true or false based on user's permission
    func isLocationAuthorized() -> Bool
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
    
    func isLocationAuthorized() -> Bool {
        return authorizationStatus == .authorizedAlways || authorizationStatus == .authorizedWhenInUse
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
















