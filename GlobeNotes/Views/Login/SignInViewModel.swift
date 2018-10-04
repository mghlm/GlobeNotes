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
    func signInUser(with email: String, password: String, completion: @escaping () -> Void)
}

struct SignInViewModel: SignInViewModelType {
    func signInUser(with email: String, password: String, completion: @escaping () -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            if let error = error {
                print("Failed to sign in user:", error)
                return
            }
            print("Successfully signed in user", user?.user.uid ?? "")
            completion()
        }
    }
}
