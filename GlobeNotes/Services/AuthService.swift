//
//  AuthService.swift
//  GlobeNotes
//
//  Created by magnus holm on 04/10/2018.
//  Copyright © 2018 magnus holm. All rights reserved.
//

import Foundation
import Firebase

protocol AuthServiceType {
    func signUpNewUser(email: String, username: String, password: String, completion: @escaping () -> Void)
    func signInUser(email: String, password: String, completion: @escaping () -> Void)
}

struct AuthService: AuthServiceType {
    var dbRef = Database.database().reference()
    
    func signUpNewUser(email: String, username: String, password: String, completion: @escaping () -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { (user, error: Error?) in
            if let error = error {
                print("Failed to create user:", error)
                return
            }
            
            print("Successfully created new user")
            completion()
            
            if let uid = user?.user.uid {
                let dictionaryValues = ["userName": username]
                let values = [uid: dictionaryValues]
                
                self.dbRef.child("users").updateChildValues(values, withCompletionBlock: { (error, databaseReference) in
                    if let error = error {
                        print("Failed to save username to db:", error)
                        return
                    }
                    print("Succesffully saved username")
                })
            }
        }
    }
    
    func signInUser(email: String, password: String, completion: @escaping () -> Void) {
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
