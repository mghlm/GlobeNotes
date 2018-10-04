//
//  SignInViewModel.swift
//  GlobeNotes
//
//  Created by magnus holm on 04/10/2018.
//  Copyright © 2018 magnus holm. All rights reserved.
//

import Foundation
import Firebase

protocol SignInViewModelType {
    
    /// Signs in a user to Firebase Authentication
    ///
    /// - Parameters:
    ///   - email: User's email address
    ///   - password: User's password they created when signing up
    ///   - completion: Completion called after successful sign in
    func signInUser(with email: String, password: String, completion: @escaping () -> Void)
}

struct SignInViewModel: SignInViewModelType {
    
    // MARK: - Dependencies
    
    fileprivate var authService: AuthServiceType!
    
    // MARK: - Init
    
    init(authService: AuthServiceType) {
        self.authService = authService
    }
    
    // Public methods
    
    func signInUser(with email: String, password: String, completion: @escaping () -> Void) {
        authService.signInUser(email: email, password: password) {
            completion()
        }
    }
}
