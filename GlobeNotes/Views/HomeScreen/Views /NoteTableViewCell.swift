//
//  NoteTableViewCell.swift
//  GlobeNotes
//
//  Created by magnus holm on 29/09/2018.
//  Copyright © 2018 magnus holm. All rights reserved.
//

import UIKit
import CoreLocation

class NoteTableViewCell: UITableViewCell {
    
    // MARK: - Public properties
    
    var note: Note! {
        didSet {
            setupUI()
        }
    }
    
    // MARK: - Private properties
    
    fileprivate var noteTitleLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.boldSystemFont(ofSize: 14)
        return lbl
    }()
    
    fileprivate var noteTextLabel: UILabel = {
        let lbl = UILabel()
        return lbl
    }()
    
    fileprivate var locationLabel: UILabel = {
        let lbl = UILabel()
        return lbl
    }()
    
    // MARK: - Private methods
    
    fileprivate func setupUI() {
        noteTitleLabel.text = note.title
        noteTextLabel.text = note.text
        setupLocationLabel()
        addSubview(noteTitleLabel)
        addSubview(noteTextLabel)
        addSubview(locationLabel)
        
        setupConstraints()
    }
    
    fileprivate func setupConstraints() {
        
    }
    
    fileprivate func fetchCityAndCountry(from location: CLLocation, completion: @escaping (_ city: String?, _ country: String?, _ error: Error?) -> ()) {
        CLGeocoder().reverseGeocodeLocation(location) { (placemarks, error) in
            completion(placemarks?.first?.locality, placemarks?.first?.country, error)
        }
    }
    
    fileprivate func setupLocationLabel() {
        let location = CLLocation(latitude: note.latitude, longitude: note.longitude)
        fetchCityAndCountry(from: location) { (city, country, error) in
            guard let city = city else { return }
            guard let country = country else { return }
            
            self.locationLabel.text = "\(city), \(country)"
        }
    }

}
