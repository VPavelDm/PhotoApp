//
//  Marker.swift
//  PhotoApp
//
//  Created by mac-089-71 on 8/31/18.
//  Copyright © 2018 VPavelDm. All rights reserved.
//

import Foundation
import MapKit

class MarkerAnnotation : NSObject, MKAnnotation {
    var category: String?
    var date: String?
    var image: UIImage?
    var photoDescription: String?
    var title: String? = ""
    var coordinate: CLLocationCoordinate2D
    init(coordinate position: CLLocationCoordinate2D) {
        self.coordinate = position
    }
}

extension MarkerAnnotation {
    static func createMarker(by photo: Photo, coordinate: CLLocationCoordinate2D) -> MarkerAnnotation {
        let marker = MarkerAnnotation(coordinate: coordinate)
        marker.category = photo.category
        marker.date = photo.date
        marker.image = photo.image
        marker.photoDescription = photo.description
        return marker
    }
}
