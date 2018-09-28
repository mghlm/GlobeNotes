//
//  HomeScreenViewController.swift
//  GlobeNotes
//
//  Created by magnus holm on 28/09/2018.
//  Copyright © 2018 magnus holm. All rights reserved.
//

import UIKit
import Firebase

class HomeScreenViewController: UIViewController {
    
    // MARK: - Private properties
    
    // MARK: - ViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        do {
            try Auth.auth().signOut()
        } catch {
            print("")
        }
        
        if Auth.auth().currentUser == nil {
            showSignUp()
        }
        
        setupUI()
    }
    
    // MARK: - Private methods
    
    fileprivate func setupUI() {
        view.backgroundColor = .white
        
        
        
        setupConstraints()
    }
    
    fileprivate func setupConstraints() {
        
    }
    
    fileprivate func showSignUp() {
        let signUpViewController = SignUpViewController()
        let navController = UINavigationController(rootViewController: signUpViewController)
        present(navController, animated: false)
    }
    
}
