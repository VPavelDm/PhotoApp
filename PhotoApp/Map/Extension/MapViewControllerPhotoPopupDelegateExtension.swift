//
//  MapViewControllerPhotoPopupDelegateExtension.swift
//  PhotoApp
//
//  Created by mac-089-71 on 9/7/18.
//  Copyright © 2018 VPavelDm. All rights reserved.
//

import Foundation

extension MapViewController: PhotoPopupDelegate {
    
    func savePhoto(photo: Photo) {
        let cloud = CloudRepository()
        cloud.sendPhotoToTheServer(photo: photo)
        if categories.contains(Category(rawValue: photo.category)!){
            addAnnotation(photo: photo)
        }
    }
    
}
