//
//  LocationManager.swift
//  GlobeNotes
//
//  Created by magnus holm on 01/10/2018.
//  Copyright © 2018 magnus holm. All rights reserved.
//

import Foundation
import CoreLocation

protocol LocationManagerType {
    
}

class LocationManager: NSObject, LocationManagerType {
    
    // MARK: - Private propreties
    
    fileprivate let locationManager: CLLocationManager = {
        let lm = CLLocationManager()
        lm.desiredAccuracy = kCLLocationAccuracyBest
        return lm
    }()
    
    // MARK: - Initialization
    
    override init() {
        super.init()
        
        locationManager.delegate = self
    }
}

extension LocationManager: CLLocationManagerDelegate {
    
}
