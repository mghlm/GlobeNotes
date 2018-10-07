//
//  NoteTableViewCell.swift
//  GlobeNotes
//
//  Created by magnus holm on 29/09/2018.
//  Copyright © 2018 magnus holm. All rights reserved.
//

import UIKit
import CoreLocation

protocol NoteTableViewCellDelegate: class {
    func getDistanceFromCurrenLocation(to note: Note) -> String 
}

final class NoteTableViewCell: UITableViewCell {
    
    // MARK: - Public properties
    
    weak var delegate: NoteTableViewCellDelegate?
    
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
        if let distance = delegate?.getDistanceFromCurrenLocation(to: note) {
            locationLabel.text = "📍 Distance: \(distance) miles"
        }
        noteAuthorLabel.text = "created at \(formattedDateString(for: note.creationDate)) by \(note.userName)"
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
    
//    fileprivate func fetchCityAndCountry(from location: CLLocation, completion: @escaping (_ city: String?, _ country: String?, _ error: Error?) -> ()) {
//        CLGeocoder().reverseGeocodeLocation(location) { (placemarks, error) in
//            completion(placemarks?.first?.locality, placemarks?.first?.country, error)
//        }
//    }
    
//    fileprivate func setupLocationLabel() {
//        if let latitude = note.latitude, let longitude = note.longitude {
//            let location = CLLocation(latitude: latitude, longitude: longitude)
//            fetchCityAndCountry(from: location) { (city, country, error) in
//                if let error = error {
//                    print("Failed to fetch location:", error)
//                    self.locationLabel.text = "📍 Failed to fetch location info"
//                }
//
//                guard let city = city else { return }
//                guard let country = country else { return }
//
//                self.locationLabel.font = UIFont.systemFont(ofSize: 14)
//                self.locationLabel.text = "📍 \(city), \(country)"
//            }
//        }
//    }
    
    fileprivate func formattedDateString(for date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        return formatter.string(from: date)
    }
}
