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
    var dbRef: DatabaseReference { get }
    
    func signUpNewUser(with email: String, username: String, password: String, completion: @escaping () -> Void)
}

struct SignUpViewModel: SignUpViewModelType {
    var dbRef: DatabaseReference = Database.database().reference()
    
    func signUpNewUser(with email: String, username: String, password: String, completion: @escaping () -> Void) {
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
}
