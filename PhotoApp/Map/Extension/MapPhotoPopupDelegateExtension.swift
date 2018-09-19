//
//  MapPhotoPopupDelegateExtension.swift
//  PhotoApp
//
//  Created by mac-089-71 on 9/19/18.
//  Copyright © 2018 VPavelDm. All rights reserved.
//

import Foundation
import UIKit

extension MapViewController: PhotoPopupDelegate {
    
    func photoAdded(photo: Photo) {
        if categories.contains(Category(rawValue: photo.category)!){
            addAnnotation(photo: photo)
        }
    }
    
    func photoUpdated(photo: Photo) {
        for annotation in mapView.annotations {
            guard let annotation = annotation as? Photo else { continue }
            if annotation == photo {
                mapView.removeAnnotation(annotation)
                break
            }
        }
        photoAdded(photo: photo)
    }
    
    func didReceivedError(error: Error) {
        let alert = UIAlertController(message: error.localizedDescription)
        present(alert, animated: true)
    }
}
