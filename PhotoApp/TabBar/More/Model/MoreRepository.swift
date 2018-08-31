//
//  MoreRepository.swift
//  PhotoApp
//
//  Created by mac-089-71 on 8/31/18.
//  Copyright © 2018 VPavelDm. All rights reserved.
//

import Foundation
import FirebaseAuth

class MoreRepository {

    func signOut(callback: @escaping (String?) -> Void) {
        let queue = DispatchQueue.global(qos: .userInitiated)
        queue.async {
            do {
                try Auth.auth().signOut()
                DispatchQueue.main.async {
                    callback(nil)
                }
            } catch let error {
                DispatchQueue.main.async {
                    callback(error.localizedDescription)
                }
            }
        }
    }
    
}
