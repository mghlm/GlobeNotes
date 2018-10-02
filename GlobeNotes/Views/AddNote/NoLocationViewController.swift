//
//  NoLocationViewController.swift.swift
//  GlobeNotes
//
//  Created by magnus holm on 02/10/2018.
//  Copyright © 2018 magnus holm. All rights reserved.
//

import Foundation
import UIKit

final class NoLocationViewController: UIViewController {
    
    // MARK: - Private properties
    
    fileprivate var mainTitleLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "Please allow the app to use your location to add a note"
        lbl.font = UIFont.boldSystemFont(ofSize: 32)
        lbl.numberOfLines = 0
        lbl.textAlignment = .center
        
        return lbl
    }()
    
    fileprivate var emojiLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "🌎"
        lbl.font = UIFont.systemFont(ofSize: 80)
        
        return lbl
    }()
    
    fileprivate var goToSettingsButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor.lightGray
        button.setTitle("Go to settings", for: .normal)
        button.addTarget(self, action: #selector(handleGoToSettings), for: .touchUpInside)
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
        
        setupConstraints()
    }
    
    fileprivate func setupConstraints() {
        guard let settingsUrl = URL(string: UIApplicationOpenSettingsURLString) else { return }
        if UIApplication.shared.canOpenURL(settingsUrl) {
            UIApplication.shared.open(settingsUrl, completionHandler: nil)
        }
    }
    
    @objc fileprivate func handleGoToSettings() {
        
    }
    
}
