//
//  SignInViewController.swift
//  GlobeNotes
//
//  Created by magnus holm on 28/09/2018.
//  Copyright © 2018 magnus holm. All rights reserved.
//

import UIKit

final class SignInViewController: UIViewController {
    
    // MARK: - Private properties
    
    fileprivate var mainTitleLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "Welcome to GlobeNote! Please log in to start exploring the world of notes"
        lbl.font = UIFont.boldSystemFont(ofSize: 24)
        lbl.textAlignment = .center
        lbl.numberOfLines = 0
        
        return lbl
    }()
    
    fileprivate var emojiLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "🌎📝"
        lbl.font = UIFont.systemFont(ofSize: 80)
        
        return lbl
    }()
    
    fileprivate var emailTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Email"
        tf.borderStyle = .roundedRect
        tf.font = UIFont.systemFont(ofSize: 14)
        tf.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
        
        return tf
    }()
    
    fileprivate var passwordTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Password"
        tf.borderStyle = .roundedRect
        tf.font = UIFont.systemFont(ofSize: 14)
        tf.isSecureTextEntry = true
        tf.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
        
        return tf
    }()
    
    fileprivate var signInButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor.lightGray
        button.setTitle("Sign in", for: .normal)
        button.addTarget(self, action: #selector(handleSignIn), for: .touchUpInside)
        button.layer.cornerRadius = 5
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.setTitleColor(.white, for: .normal)
        button.isEnabled = false
        
        return button
    }()
    
    fileprivate var dontHaveAccountButton: UIButton = {
        let button = UIButton()
        button.setTitle("Don't have an account? Sign up!", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.addTarget(self, action: #selector(handleSignUp), for: .touchUpInside)
        
        return button
    }()
    
    fileprivate var stackView: UIStackView!
    
    // MARK: - ViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    // MARK: - Private methods
    
    fileprivate func setupUI() {
        view.backgroundColor = .white
        
        view.addSubview(mainTitleLabel)
        view.addSubview(emojiLabel)
        stackView = UIStackView(arrangedSubviews: [emailTextField, passwordTextField, signInButton])
        stackView.distribution = .fillEqually
        stackView.axis = .vertical
        stackView.spacing = 10
        view.addSubview(stackView)
        
        setupConstraints()
    }
    
    fileprivate func setupConstraints() {
        
    }
    
    @objc fileprivate func handleTextInputChange() {
        
    }
    
    @objc fileprivate func handleSignIn() {
        
    }
    
    @objc fileprivate func handleSignUp() {
        
    }
    
}






















