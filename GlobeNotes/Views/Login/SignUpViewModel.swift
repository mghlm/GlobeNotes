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
