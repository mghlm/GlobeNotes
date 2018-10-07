//
//  NoteDetailsPresenter.swift
//  GlobeNotes
//
//  Created by magnus holm on 06/10/2018.
//  Copyright © 2018 magnus holm. All rights reserved.
//

import Foundation
import CoreLocation

protocol NoteDetailsPresenterType {
    func fetchCityAndCountry(from location: CLLocation, completion: @escaping (_ city: String?, _ country: String?, _ error: Error?) -> ())
}

struct NoteDetailsPresenter: NoteDetailsPresenterType {
    
    // MARK: - Public methods
    
    func fetchCityAndCountry(from location: CLLocation, completion: @escaping (_ city: String?, _ country: String?, _ error: Error?) -> ()) {
        CLGeocoder().reverseGeocodeLocation(location) { (placemarks, error) in
            completion(placemarks?.first?.locality, placemarks?.first?.country, error)
        }
    }
}
