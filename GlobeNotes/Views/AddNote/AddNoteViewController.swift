//
//  AddNoteViewController.swift
//  GlobeNotes
//
//  Created by magnus holm on 30/09/2018.
//  Copyright © 2018 magnus holm. All rights reserved.
//

import UIKit

class AddNoteViewController: UIViewController {
    
    // MARK: - Private properties
    
    fileprivate var titleTextField: UITextField = {
        let tv = UITextField()
        
        return tv
    }()
    
    fileprivate var textTextField: UITextField = {
        let tv = UITextField()
        
        return tv
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
        
    }
    
}
