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
    var category: String
    var coordinate: CLLocationCoordinate2D
    init(category: String, coordinate position: CLLocationCoordinate2D) {
        self.category = category
        self.coordinate = position
    }
}
