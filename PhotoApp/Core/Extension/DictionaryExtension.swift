//
//  DictionaryExtension.swift
//  PhotoApp
//
//  Created by mac-089-71 on 9/20/18.
//  Copyright © 2018 VPavelDm. All rights reserved.
//

import Foundation
import UIKit
import FirebaseDatabase
import MapKit

extension Dictionary where Key == String, Value == Any {
    func createPhoto(image: UIImage) -> Photo {
        let photoLatitude = self[#keyPath(Photo.latitude)]! as! Double
        let photoLongitude = self[#keyPath(Photo.longitude)]! as! Double
        let photoCategory = self[#keyPath(Photo.category)] as! String
        let photoDate = TimeInterval(truncating: self[#keyPath(Photo.date)] as! NSNumber)
        let photoDescription = self[#keyPath(Photo.description)] as! String
        let key = self[#keyPath(DataSnapshot.key)] as! String
        let coordinate = CLLocationCoordinate2D(latitude: photoLatitude, longitude: photoLongitude)
        return Photo(key: key, description: photoDescription, category: photoCategory, date: Date(timeIntervalSince1970: photoDate), image: image, coordinate: coordinate)
    }
}
