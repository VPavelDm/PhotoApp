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

class Photo: NSObject, MKAnnotation {
    @objc var key: String = ""
    @objc var photoDescription: String = ""
    @objc var category: String = ""
    @objc var date: String = ""
    @objc private(set) var latitude: Double = 0
    @objc private(set) var longitude: Double = 0
    @objc var image: UIImage
    var coordinate: CLLocationCoordinate2D 
    var subtitle: String? = ""
    var title: String? = ""

    init(coordinate: CLLocationCoordinate2D, image: UIImage) {
        self.coordinate = coordinate
        self.latitude = coordinate.latitude
        self.longitude = coordinate.longitude
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
        self.latitude = coordinate.latitude
        self.longitude = coordinate.longitude
        
        super.init()
    }
    
    override func isEqual(_ object: Any?) -> Bool {
        guard let photo = object as? Photo else { return false }
        return photo.key == key && !key.isEmpty
    }
}

extension Photo {
    func toMap(key: String) -> [String: Any] {
        self.key = key
        let photoDescriptionData: [String: Any] = [#keyPath(User.uid): Auth.auth().currentUser!.uid,
                                                   #keyPath(Photo.key): self.key,
                                                   #keyPath(Photo.category): category,
                                                   #keyPath(Photo.date): date,
                                                   #keyPath(Photo.description): photoDescription,
                                                   #keyPath(Photo.latitude): latitude,
                                                   #keyPath(Photo.longitude): longitude]
        return photoDescriptionData
    }
}
