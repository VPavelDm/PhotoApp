//
//  Photo.swift
//  PhotoApp
//
//  Created by mac-089-71 on 9/5/18.
//  Copyright © 2018 VPavelDm. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class Photo: NSObject, MKAnnotation {
    var key: String = ""
    var photoDescription: String = ""
    var category: String = ""
    var date: String = ""
    var image: UIImage
    var coordinate: CLLocationCoordinate2D
    var subtitle: String? = ""
    var title: String? = ""

    init(coordinate: CLLocationCoordinate2D, image: UIImage) {
        self.coordinate = coordinate
        self.image = image
        super.init()
    }
    
    init(key: String, description: String, category: String, date: String, image: UIImage, coordinate: CLLocationCoordinate2D) {
        self.key = key
        self.photoDescription = description
        self.category = category
        self.date = date
        self.image = image
        self.coordinate = coordinate
        
        super.init()
    }
}
