//
//  SignUpRepository.swift
//  PhotoApp
//
//  Created by mac-089-71 on 8/31/18.
//  Copyright © 2018 VPavelDm. All rights reserved.
//

import Foundation
import FirebaseAuth

class SignUpRepository {
    
    func signUp(email login: String, password: String, confirmPassword: String, callback: @escaping (String?) -> Void) {
        if password != confirmPassword {
            callback(NSLocalizedString("Passwords do not match", comment: "Error message"))
            return
        }
        Auth.auth().createUser(withEmail: login, password: password) { (authResult, error) in
            if let error = error {
                callback(error.localizedDescription)
            } else {
                callback(nil)
            }
        }
    }
    
}
