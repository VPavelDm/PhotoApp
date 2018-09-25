//
//  LoginRepository.swift
//  PhotoApp
//
//  Created by mac-089-71 on 8/31/18.
//  Copyright © 2018 VPavelDm. All rights reserved.
//

import Foundation
import FirebaseAuth

class LoginRepository {
    
    func signIn(email login: String, password: String, callback: @escaping (String?) -> Void) {
        Auth.auth().signIn(withEmail: login, password: password) { (authDataResult, error) in
            if let error = error {
                callback(error.localizedDescription)
            } else {
                callback(nil)
            }
        }
    }
    
}
