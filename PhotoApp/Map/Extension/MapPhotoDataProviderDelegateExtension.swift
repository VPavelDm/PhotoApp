//
//  MapPhotoDataProviderDelegateExtension.swift
//  PhotoApp
//
//  Created by mac-089-71 on 9/19/18.
//  Copyright © 2018 VPavelDm. All rights reserved.
//

import Foundation

extension MapViewController: MapPhotoDataProviderDelegate {
    func didReceivedPhotos(photos: [Photo]) {
        mapView.removeAnnotations(mapView.annotations)
        for photo in photos {
            addAnnotation(photo: photo)
        }
    }    
}
