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
    
    // MARK: - Private properties
    
    fileprivate var mainTitleLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.boldSystemFont(ofSize: 24)
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
    
    fileprivate var imageView: UIImageView = {
        let iv = UIImageView()
        
        return iv
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
//        if let imageUrl = note.imageUrl {
//            setupImageView(with: imageUrl)
//        }
        view.addSubview(imageView)
        setupConstraints()
    }
    
    fileprivate func setupConstraints() {
        mainTitleLabel.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 115, paddingLeft: 24, paddingBottom: 0, paddingRight: 24, width: 0, height: 0)
        contentView.anchor(top: mainTitleLabel.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 24, paddingLeft: 24, paddingBottom: 0, paddingRight: 24, width: 0, height: 0)
        contentLabel.anchor(top: contentView.topAnchor, left: contentView.leftAnchor, bottom: contentView.bottomAnchor, right: contentView.rightAnchor, paddingTop: 8, paddingLeft: 8, paddingBottom: 8, paddingRight: 8, width: 0, height: 0)
        cityCountryLabel.anchor(top: contentLabel.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 24, paddingLeft: 24, paddingBottom: 0, paddingRight: 24, width: 0, height: 0)
        imageView.anchor(top: contentLabel.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 30, paddingLeft: 24, paddingBottom: 0, paddingRight: 24, width: 0, height: 0)
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
            
            self.cityCountryLabel.text = "🗺 Note submitted in \(city), \(country)"
        }
    }
    
//    fileprivate func setupImageView(with imageUrl: String) {
//        guard let url = URL(string: imageUrl) else { return }
//        
//        URLSession.shared.dataTask(with: url) { (data, response, error) in
//            if let error = error {
//                print("Failed to fetch user profile image:", error.localizedDescription)
//                return
//            }
//            guard let data = data else { return }
//            let image = UIImage(data: data)
//            DispatchQueue.main.async {
//                self.imageView.image = image
//                self.imageView.layer.cornerRadius = 10
//                self.imageView.clipsToBounds = true
//            }
//            }.resume()
//    }
    
}
