//
//  MapPhotoManagerDelegate.swift
//  PhotoApp
//
//  Created by mac-089-71 on 9/13/18.
//  Copyright © 2018 VPavelDm. All rights reserved.
//

import Foundation
import UIKit

extension MapViewController: PhotoManagerDelegate {
    func photoChanged(photo: Photo) {
        addAnnotation(photo: photo)
    }
    
    func error(message error: String) {
        let alert = UIAlertController(message: error)
        present(alert, animated: true)
    }
    
    
}
