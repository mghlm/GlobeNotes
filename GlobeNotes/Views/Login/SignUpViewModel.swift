//
//  SignUpViewModel.swift
//  GlobeNotes
//
//  Created by magnus holm on 04/10/2018.
//  Copyright © 2018 magnus holm. All rights reserved.
//

import Foundation
import Firebase

protocol SignUpViewModelType {
    
    /// Creates a new account and signs it up to Firebase Authentication
    ///
    /// - Parameters:
    ///   - email: User's email input
    ///   - username: User's username input
    ///   - password: User's password input
    ///   - completion: Completion called when new account is successfully created and saved in the database
    func signUpNewUser(with email: String, username: String, password: String, completion: @escaping () -> Void)
}

struct SignUpViewModel: SignUpViewModelType {
    
    // MARK: - Dependencies
    
    fileprivate var authService: AuthServiceType!
    
    // MARK: - Prive properties
    
    private var dbRef: DatabaseReference = Database.database().reference()
    
    // MARK: - Init
    
    init(authService: AuthServiceType) {
        self.authService = authService
    }
    
    func signUpNewUser(with email: String, username: String, password: String, completion: @escaping () -> Void) {
        authService.signUpNewUser(email: email, username: username, password: password) { () in
            completion()
        }
    }
}
