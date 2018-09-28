//
//  SignUpViewController.swift
//  GlobeNotes
//
//  Created by magnus holm on 28/09/2018.
//  Copyright © 2018 magnus holm. All rights reserved.
//

import UIKit
import FirebaseAuth

class SignUpViewController: UIViewController {
    
    // MARK: - Private Properties
    
    fileprivate var mainTitleLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "Welcome to GlobeNote! Please sign up to start adding notes to the world 😊"
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
    
    fileprivate var usernameTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "User name"
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
    
    fileprivate var signUpButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor.lightGray
        button.setTitle("Sign up", for: .normal)
        button.addTarget(self, action: #selector(handleSignUp), for: .touchUpInside)
        button.layer.cornerRadius = 5
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.setTitleColor(.white, for: .normal)
        button.isEnabled = false
        
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
        
        stackView = UIStackView(arrangedSubviews: [emailTextField, usernameTextField, passwordTextField, signUpButton])
        stackView.distribution = .fillEqually
        stackView.axis = .vertical
        stackView.spacing = 10
        view.addSubview(stackView)
        
        setupConstraints()
    }
    
    fileprivate func setupConstraints() {
        mainTitleLabel.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 100, paddingLeft: 24, paddingBottom: 0, paddingRight: 24, width: 0, height: 0)
        emojiLabel.anchor(centerX: view.centerXAnchor, centerY: nil)
        emojiLabel.anchor(top: mainTitleLabel.bottomAnchor, left: nil, bottom: nil, right: nil, paddingTop: 50, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        stackView.anchor(top: emojiLabel.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 25, paddingLeft: 40, paddingBottom: 0, paddingRight: 40, width: 0, height: 200)
    }
    
    @objc fileprivate func handleTextInputChange() {
        guard let email = emailTextField.text, !email.isEmpty else { return }
        guard let username = usernameTextField.text, !username.isEmpty else { return }
        guard let password = passwordTextField.text, !password.isEmpty else { return }
        
        Auth.auth().createUser(withEmail: email, password: password) { (user, error: Error?) in
            if let error = error {
                print("Failed to create user:", error)
                return
            }
            print("Successfully created user:", user?.uid ?? "")
            
            guard let image = self.addPhotoButton.imageView?.image else { return }
            guard let uploadData = image.jpegData(compressionQuality: 0.5) else { return }
            let filename = NSUUID().uuidString
            
            let storageReference = Storage.storage().reference()
            let storageReferenceChild = storageReference.child("profile_images").child(filename)
            
            storageReferenceChild.putData(uploadData, metadata: nil, completion: { (metaData, error) in
                if let error = error {
                    print("Failed to upload image:", error.localizedDescription)
                    return
                }
                
                storageReferenceChild.downloadURL(completion: { (url, error) in
                    if let error = error {
                        print("Failed to retrieve URL:", error.localizedDescription)
                        return
                    }
                    let profileImageUrl = url?.absoluteString
                    print("Profile image successfully downloadet: \(profileImageUrl ?? "")")
                    
                    guard let uid = user?.uid else { return }
                    let dictionaryValues = ["username": username, "profileImageUrl": profileImageUrl]
                    let values = [uid: dictionaryValues]
                    
                    Database.database().reference().child("users").updateChildValues(values, withCompletionBlock: { (error, reference) in
                        if let error = error {
                            print("Failed to save user info into DB:", error.localizedDescription)
                            return
                        }
                        
                        print("Successfully saved user info into DB")
                        
                        guard let mainTabBarController = UIApplication.shared.keyWindow?.rootViewController as? MainTabBarController else { return }
                        mainTabBarController.setupViewControllers()
                        
                        self.dismiss(animated: true, completion: nil)
                    })
                })
            })
        }
    }
    
    @objc fileprivate func handleSignUp() {
        
    }
}
























