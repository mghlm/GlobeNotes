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
    
    /// Gets the distance from user's current location to the given note
    ///
    /// - Parameter note: The note to calculate distance to
    /// - Returns: Distance in miles as string 
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
        return lbl
    }()
    
    // MARK: - Private methods
    
    fileprivate func setupUI() {
        noteTitleLabel.text = "✏️ \(note.title)"
        if let distance = delegate?.getDistanceFromCurrenLocation(to: note), distance != "" {
            locationLabel.text = "📍 Distance: \(distance) miles"
        }
        noteAuthorLabel.text = "created \(formattedDateString(for: note.creationDate)) by \(note.userName)"
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
    
    fileprivate func formattedDateString(for date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        return formatter.string(from: date)
    }
}
