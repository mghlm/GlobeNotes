//
//  SignUpViewController.swift
//  GlobeNotes
//
//  Created by magnus holm on 28/09/2018.
//  Copyright © 2018 magnus holm. All rights reserved.
//

import UIKit

final class SignUpViewController: UIViewController {
    
    // MARK: - Dependencies
    
    var presenter: SignUpPresenterType!
    
    // MARK: - Private Properties
    
    fileprivate var mainTitleLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "Create a profile to start sharing your notes with the world!"
        lbl.font = UIFont.boldSystemFont(ofSize: 24)
        lbl.textAlignment = .center
        lbl.numberOfLines = 0
        
        return lbl
    }()
    
    fileprivate var emojiLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "📍✏️"
        lbl.font = UIFont.systemFont(ofSize: 40)
        
        return lbl
    }()
    
    fileprivate var emailTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Email"
        tf.borderStyle = .roundedRect
        tf.font = UIFont.systemFont(ofSize: 14)
        tf.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
        tf.accessibilityIdentifier = "emailTextField"
        
        return tf
    }()
    
    fileprivate var usernameTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "User name"
        tf.borderStyle = .roundedRect
        tf.font = UIFont.systemFont(ofSize: 14)
        tf.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
        tf.accessibilityIdentifier = "usernameTextField"
        
        return tf
    }()
    
    fileprivate var passwordTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Password"
        tf.borderStyle = .roundedRect
        tf.font = UIFont.systemFont(ofSize: 14)
        tf.isSecureTextEntry = true
        tf.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
        tf.accessibilityIdentifier = "passwordTextField"
        
        return tf
    }()
    
    fileprivate var signUpButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor.lightGray
        button.setTitle("Sign up", for: .normal)
        button.addTarget(self, action: #selector(handleSignUp), for: .touchUpInside)
        button.layer.cornerRadius = 5
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.setTitleColor(.white, for: .normal)
        button.isEnabled = false
        button.accessibilityIdentifier = "submitButton"
        
        return button
    }()
    
    fileprivate var stackView: UIStackView!
    fileprivate var dismissKeyboardGestureRecognizer: UIGestureRecognizer!
    
    // MARK: - Shared
    
    static let successAlert = NSNotification.Name(rawValue: "successSignUpAlert")
    
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
        stackView = UIStackView(arrangedSubviews: [emailTextField, usernameTextField, passwordTextField, signUpButton])
        stackView.distribution = .fillEqually
        stackView.axis = .vertical
        stackView.spacing = 10
        view.addSubview(stackView)
        dismissKeyboardGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleDismissKeyboard))
        view.addGestureRecognizer(dismissKeyboardGestureRecognizer)
        
        setupConstraints()
    }
    
    fileprivate func setupConstraints() {
        mainTitleLabel.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 100, paddingLeft: 24, paddingBottom: 0, paddingRight: 24, width: 0, height: 0)
        emojiLabel.anchor(centerX: view.centerXAnchor, centerY: nil)
        emojiLabel.anchor(top: mainTitleLabel.bottomAnchor, left: nil, bottom: nil, right: nil, paddingTop: 10, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        stackView.anchor(top: emojiLabel.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 10, paddingLeft: 40, paddingBottom: 0, paddingRight: 40, width: 0, height: 200)
    }
    
    @objc fileprivate func handleTextInputChange() {
        let isFormValid = emailTextField.text?.isEmpty == false && usernameTextField.text?.isEmpty == false && passwordTextField.text?.isEmpty == false
        
        if isFormValid {
            signUpButton.isEnabled = true
            signUpButton.backgroundColor = UIColor.rgb(red: 0, green: 122, blue: 255)
        } else {
            signUpButton.isEnabled = false
            signUpButton.backgroundColor = UIColor.lightGray
        }
    }
    
    @objc fileprivate func handleSignUp() {
        guard let email = emailTextField.text, !email.isEmpty else { return }
        guard let username = usernameTextField.text, !username.isEmpty else { return }
        guard let password = passwordTextField.text, !password.isEmpty else { return }
        
        presenter.signUpNewUser(with: email, username: username, password: password, completion: {
            self.dismiss(animated: true, completion: {
                NotificationCenter.default.post(name: SignUpViewController.successAlert, object: nil)
            })
        })
    }
    
    @objc fileprivate func handleDismissKeyboard() {
        view.endEditing(true)
    }
}
