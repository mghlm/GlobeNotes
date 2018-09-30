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
    
    static let id = "NoteTableViewCell"
    
    // MARK: - Private properties
    
    fileprivate var noteTitleLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.boldSystemFont(ofSize: 24)
        return lbl
    }()
    
    fileprivate var noteAuthorLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.italicSystemFont(ofSize: 10)
        lbl.textColor = .gray
        return lbl
    }()
    
    fileprivate var locationLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.italicSystemFont(ofSize: 14)
        lbl.text = "Fetching location..."
        return lbl
    }()
    
    // MARK: - Private methods
    
    fileprivate func setupUI() {
        noteTitleLabel.text = "✏️ \(note.title)"
        setupLocationLabel()
        noteAuthorLabel.text = "created at \(note.creationDate.description) by \(note.user?.name ?? "")"
        addSubview(noteTitleLabel)
        addSubview(locationLabel)
        addSubview(noteAuthorLabel)
        
        setupConstraints()
    }
    
    fileprivate func setupConstraints() {
        noteTitleLabel.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 8, paddingLeft: 8, paddingBottom: 0, paddingRight: 8, width: 0, height: 0)
        locationLabel.anchor(top: noteTitleLabel.bottomAnchor, left: leftAnchor, bottom: nil, right: nil, paddingTop: 8, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        noteAuthorLabel.anchor(top: locationLabel.bottomAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 8, paddingLeft: 8, paddingBottom: 8, paddingRight: 8, width: 0, height: 0)
    }
    
    fileprivate func fetchCityAndCountry(from location: CLLocation, completion: @escaping (_ city: String?, _ country: String?, _ error: Error?) -> ()) {
        CLGeocoder().reverseGeocodeLocation(location) { (placemarks, error) in
            completion(placemarks?.first?.locality, placemarks?.first?.country, error)
        }
    }
    
    fileprivate func setupLocationLabel() {
        let location = CLLocation(latitude: note.latitude, longitude: note.longitude)
        fetchCityAndCountry(from: location) { (city, country, error) in
            if let error = error {
                print("Failed to fetch location:", error)
                self.locationLabel.text = "📍 Can't fetch location data"
            }
            
            guard let city = city else { return }
            guard let country = country else { return }
            
            self.locationLabel.font = UIFont.systemFont(ofSize: 14)
            self.locationLabel.text = "📍 \(city), \(country)"
        }
    }
}
