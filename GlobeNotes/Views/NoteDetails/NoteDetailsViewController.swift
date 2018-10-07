//
//  NoteDetailsViewController.swift
//  GlobeNotes
//
//  Created by magnus holm on 02/10/2018.
//  Copyright © 2018 magnus holm. All rights reserved.
//

import UIKit

final class NoteDetailsViewController: UIViewController {
    
    // MARK: - Dependencies
    
    var presenter: NoteDetailsPresenterType!
    
    // MARK: - Public properties
    
    var note: Note! {
        didSet {
            setupUI()
        }
    }
    
    var uid: String?
    
    // MARK: - Private properties
    
    fileprivate var mainTitleLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.boldSystemFont(ofSize: 32)
        lbl.numberOfLines = 0
        
        return lbl
    }()
    
    fileprivate var contentView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.rgb(red: 242, green: 242, blue: 242)
        view.layer.cornerRadius = 8
        view.clipsToBounds = true
        
        return view
    }()
    
    fileprivate var contentLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.systemFont(ofSize: 18)
        lbl.numberOfLines = 0
        
        return lbl
    }()
    
    fileprivate var cityCountryLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.italicSystemFont(ofSize: 14)
        
        return lbl
    }()
    
    fileprivate var goToMapButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor.rgb(red: 0, green: 122, blue: 255)
        button.setTitle("See note on map", for: .normal)
        button.addTarget(self, action: #selector(handleGoToMap), for: .touchUpInside)
        button.layer.cornerRadius = 5
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.setTitleColor(.white, for: .normal)
        
        return button
    }()
    
    fileprivate var deleteNoteButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor.red
        button.setTitle("Delete note", for: .normal)
        button.addTarget(self, action: #selector(handleDeleteNote), for: .touchUpInside)
        button.layer.cornerRadius = 5
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.setTitleColor(.white, for: .normal)
        
        return button
    }()
    
    // MARK: - ViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    // MARK: - Private methods
    
    fileprivate func setupUI() {
        view.backgroundColor = .white
        
        navigationItem.largeTitleDisplayMode = .never
        
        mainTitleLabel.text = "\(note.title)"
        view.addSubview(mainTitleLabel)
        view.addSubview(contentView)
        contentLabel.text = "\(note.text)"
        contentView.addSubview(contentLabel)
        setupCityCountryLabel()
        view.addSubview(cityCountryLabel)
        view.addSubview(goToMapButton)
        if let uid = uid, uid == note.uid {
            setupDeleteButton()
        }
        
        setupConstraints()
    }
    
    fileprivate func setupConstraints() {
        mainTitleLabel.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 115, paddingLeft: 24, paddingBottom: 0, paddingRight: 24, width: 0, height: 0)
        contentView.anchor(top: mainTitleLabel.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 24, paddingLeft: 24, paddingBottom: 0, paddingRight: 24, width: 0, height: 0)
        contentLabel.anchor(top: contentView.topAnchor, left: contentView.leftAnchor, bottom: contentView.bottomAnchor, right: contentView.rightAnchor, paddingTop: 8, paddingLeft: 8, paddingBottom: 8, paddingRight: 8, width: 0, height: 0)
        cityCountryLabel.anchor(top: contentLabel.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 24, paddingLeft: 24, paddingBottom: 0, paddingRight: 24, width: 0, height: 0)
        goToMapButton.anchor(top: cityCountryLabel.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 24, paddingLeft: 24, paddingBottom: 0, paddingRight: 24, width: 0, height: 0)
    }
    
    fileprivate func setupCityCountryLabel() {
        presenter.fetchCityAndCountry(from: note.location) { (city, country, error) in
            if let error = error {
                print("Failed to fetch placemarks:", error)
                self.cityCountryLabel.text = ""
                return
            }
            guard let city = city else { return }
            guard let country = country else { return }
            self.cityCountryLabel.text = "📍 Note submitted in \(city), \(country)"
        }
    }
    
    fileprivate func setupDeleteButton() {
        view.addSubview(deleteNoteButton)
        deleteNoteButton.anchor(top: goToMapButton.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 8, paddingLeft: 24, paddingBottom: 0, paddingRight: 24, width: 0, height: 0)
    }
    
    // MARK: - Handlers
    
    @objc fileprivate func handleGoToMap() {
        guard let navController = navigationController else { return }
        presenter.navigateToMapScreen(in: navController, with: note)
    }
    
    @objc fileprivate func handleDeleteNote() {
        
    }
}
