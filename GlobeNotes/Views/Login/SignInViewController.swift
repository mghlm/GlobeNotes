//
//  SignInViewController.swift
//  GlobeNotes
//
//  Created by magnus holm on 28/09/2018.
//  Copyright © 2018 magnus holm. All rights reserved.
//

import UIKit
import Firebase

final class SignInViewController: UIViewController {
    
    // MARK: - Dependencies
    
    var presenter: SignInPresenterType!
    
    // MARK: - Private properties
    
    fileprivate var mainTitleLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "Welcome to GlobeNote! Please sign in"
        lbl.font = UIFont.boldSystemFont(ofSize: 24)
        lbl.textAlignment = .center
        lbl.numberOfLines = 0
        
        return lbl
    }()
    
    fileprivate var emojiLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "🌎📝"
        lbl.font = UIFont.systemFont(ofSize: 40)
        
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
        let button = UIButton(type: .system)
        button.setTitle("Don't have an account? Sign up!", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.addTarget(self, action: #selector(handlePushToSignUp), for: .touchUpInside)
        
        return button
    }()
    
    fileprivate var stackView: UIStackView!
    fileprivate var dismissKeyboardGestureRecognizer: UIGestureRecognizer!
    
    // MARK: - Constants
    
    static let successAlert = NSNotification.Name(rawValue: "successSignInAlert")
    
    // MARK: - ViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    // MARK: - Private methods
    
    fileprivate func setupUI() {
        view.backgroundColor = .white
        navigationController?.navigationBar.barTintColor = .white 
        
        view.addSubview(mainTitleLabel)
        view.addSubview(emojiLabel)
        stackView = UIStackView(arrangedSubviews: [emailTextField, passwordTextField, signInButton])
        stackView.distribution = .fillEqually
        stackView.axis = .vertical
        stackView.spacing = 10
        view.addSubview(stackView)
        view.addSubview(dontHaveAccountButton)
        dismissKeyboardGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleDismissKeyboard))
        view.addGestureRecognizer(dismissKeyboardGestureRecognizer)
        
        setupConstraints()
    }
    
    fileprivate func setupConstraints() {
        mainTitleLabel.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 100, paddingLeft: 24, paddingBottom: 0, paddingRight: 24, width: 0, height: 0)
        emojiLabel.anchor(centerX: view.centerXAnchor, centerY: nil)
        emojiLabel.anchor(top: mainTitleLabel.bottomAnchor, left: nil, bottom: nil, right: nil, paddingTop: 10, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        stackView.anchor(top: emojiLabel.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 20, paddingLeft: 40, paddingBottom: 0, paddingRight: 40, width: 0, height: 150)
        dontHaveAccountButton.anchor(centerX: view.centerXAnchor, centerY: nil)
        dontHaveAccountButton.anchor(top: nil, left: nil, bottom: view.bottomAnchor, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 40, paddingRight: 0, width: 0, height: 0)
    }
    
    @objc fileprivate func handleTextInputChange() {
        let isFormValid = emailTextField.text?.isEmpty == false && passwordTextField.text?.isEmpty == false
        
        if isFormValid {
            signInButton.isEnabled = true
            signInButton.backgroundColor = UIColor.rgb(red: 0, green: 122, blue: 255)
        } else {
            signInButton.isEnabled = false
            signInButton.backgroundColor = UIColor.lightGray
        }
    }
    
    @objc fileprivate func handleSignIn() {
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        
        presenter.signInUser(with: email, password: password) {
            self.dismiss(animated: true, completion: {
                NotificationCenter.default.post(name: SignInViewController.successAlert, object: nil)
            })
        }
    }
    
    @objc fileprivate func handlePushToSignUp() {
        let signUpViewController = SignUpViewController()
        navigationController?.pushViewController(signUpViewController, animated: true)
    }
    
    @objc fileprivate func handleDismissKeyboard() {
        view.endEditing(true)
    }
}






















