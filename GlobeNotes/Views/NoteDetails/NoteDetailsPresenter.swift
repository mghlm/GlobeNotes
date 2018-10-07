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
    
    
    
    func fetchCityAndCountry(from location: CLLocation, completion: @escaping (_ city: String?, _ country: String?, _ error: Error?) -> ()) {
        CLGeocoder().reverseGeocodeLocation(location) { (placemarks, error) in
            completion(placemarks?.first?.locality, placemarks?.first?.country, error)
        }
    }
    
    
    
    
    
//
//        fileprivate func setupLocationLabel() {
//            if let latitude = note.latitude, let longitude = note.longitude {
//                let location = CLLocation(latitude: latitude, longitude: longitude)
//                fetchCityAndCountry(from: location) { (city, country, error) in
//                    if let error = error {
//                        print("Failed to fetch location:", error)
//                        self.locationLabel.text = "📍 Failed to fetch location info"
//                    }
//
//                    guard let city = city else { return }
//                    guard let country = country else { return }
//
//                    self.locationLabel.font = UIFont.systemFont(ofSize: 14)
//                    self.locationLabel.text = "📍 \(city), \(country)"
//                }
//            }
//        }
    
}
