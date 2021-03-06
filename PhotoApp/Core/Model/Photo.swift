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
import FirebaseAuth
import FirebaseDatabase

class Photo: NSObject, MKAnnotation {
    // It's photo description key in the firebase.. Used to compare two objects and to find node in the firebase to update information
    @objc var key: String
    @objc var photoDescription: String
    @objc var category: String
    @objc var date: Date?
    @objc var url: URL?
    var coordinate: CLLocationCoordinate2D
    var subtitle: String? = ""
    var title: String? = ""
    
    init(key: String, description: String, category: String, date: Date?, coordinate: CLLocationCoordinate2D, url: URL?) {
        self.key = key
        self.photoDescription = description
        self.category = category
        self.date = date
        self.coordinate = coordinate
        self.url = url
        
        super.init()
    }
    
    convenience init(coordinate: CLLocationCoordinate2D) {
        self.init(key: "", description: "", category: "", date: nil, coordinate: coordinate, url: nil)
    }
    
    convenience init(description: [String: Any]) {
        let photoLatitude = description[Photo.latitude]! as! Double
        let photoLongitude = description[Photo.longitude]! as! Double
        let photoCategory = description[#keyPath(Photo.category)] as! String
        let photoDate = TimeInterval(truncating: description[#keyPath(Photo.date)] as! NSNumber)
        let photoDescription = description[#keyPath(Photo.description)] as! String
        let key = description[#keyPath(DataSnapshot.key)] as! String
        let url = description[#keyPath(Photo.url)] as! URL
        let coordinate = CLLocationCoordinate2D(latitude: photoLatitude, longitude: photoLongitude)
        self.init(key: key, description: photoDescription, category: photoCategory, date: Date(timeIntervalSince1970: photoDate), coordinate: coordinate, url: url)
    }
    
    func toMap() -> [String: Any] {
        let photoDescriptionData: [String: Any] = [#keyPath(User.uid): Auth.auth().currentUser!.uid,
                                                   #keyPath(Photo.key): self.key,
                                                   #keyPath(Photo.category): category,
                                                   #keyPath(Photo.date): date!.timeIntervalSince1970 as NSNumber,
                                                   #keyPath(Photo.description): photoDescription,
                                                   Photo.latitude: coordinate.latitude,
                                                   Photo.longitude: coordinate.longitude]
        return photoDescriptionData
    }
    
    private static let latitude = "latitude"
    private static let longitude = "longitude"
    
}

extension Photo {
    static func ==(lhs: Photo, rhs: Photo) -> Bool {
        return lhs.key == rhs.key && !lhs.key.isEmpty
    }
}
