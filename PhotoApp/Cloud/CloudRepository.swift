//
//  CloudRepository.swift
//  PhotoApp
//
//  Created by mac-089-71 on 9/5/18.
//  Copyright © 2018 VPavelDm. All rights reserved.
//

import Foundation
import FirebaseStorage
import FirebaseDatabase
import MapKit

class CloudRepository {
    
    private let latitude = "latitude"
    private let longitude = "longitude"
    private let rootReference = "photos"
    private let category = "category"
    private let date = "date"
    private let description = "description"
    
    private let storageRef: StorageReference
    private let databaseRef: DatabaseReference
    
    init() {
        storageRef = Storage.storage().reference().child(rootReference)
        databaseRef = Database.database().reference().child(rootReference)
    }
    
    func sendPhotoToTheServer(photo: Photo, callback: @escaping (String) -> ()) {
        let photoDescriptionRef = databaseRef.childByAutoId()
        let photoDescriptionData: [String: Any] = [category: photo.category, date: photo.date, description: photo.photoDescription, latitude: photo.latitude, longitude: photo.longitude]
        photoDescriptionRef.setValue(photoDescriptionData)
        
        let imageRef = storageRef.child(photo.category).child(photoDescriptionRef.key)
        guard let imageData = UIImagePNGRepresentation(photo.image) else { return }
        imageRef.putData(imageData, metadata: nil) { (metadata, error) in
            if let error = error {
                callback(error.localizedDescription)
            }
        }
    }
    
    func getPhotos(callback: @escaping (Photo) -> ()) {
        databaseRef.observeSingleEvent(of: DataEventType.value) { [weak self] (snapshot) in
            for idSnapshot in snapshot.children {
                if let idSnapshot = idSnapshot as? DataSnapshot, let photoDescriptionDictionary = idSnapshot.value as? [String: Any] {
                    guard
                        let `self` = self,
                        let photoLatitude = photoDescriptionDictionary[self.latitude] as? Double,
                        let photoLongitude = photoDescriptionDictionary[self.longitude] as? Double,
                        let photoCategory = photoDescriptionDictionary[#keyPath(Photo.category)] as? String,
                        let photoDate = photoDescriptionDictionary[#keyPath(Photo.date)] as? String,
                        let photoDescription = photoDescriptionDictionary[#keyPath(Photo.description)] as? String else { return }
                    let imageRef = self.storageRef.child(photoCategory).child(idSnapshot.key)
                    imageRef.downloadTestURL(completion: { (url, error) in
                        guard let url = url else { return }
                        if let imageData = try? Data(contentsOf: url) {
                            guard let image = UIImage(data: imageData) else { return }
                            let coordinate = CLLocationCoordinate2D(latitude: photoLatitude, longitude: photoLongitude)
                            let photo = Photo(key: idSnapshot.key, description: photoDescription, category: photoCategory, date: photoDate, image: image, coordinate: coordinate)
                            callback(photo)
                        }
                    })
                }
            }
        }
    }
}

extension StorageReference {
    func downloadTestURL(completion: @escaping (_ url: URL?, _ error: Error?) -> ()) {
        DispatchQueue.global(qos: .userInitiated).async {
            DispatchQueue.main.async {
                completion(URL(string: "https://cdn1-www.dogtime.com/assets/uploads/gallery/shiba-inu-dog-breed-picutres/thumbs/thumbs_8-side.jpg"), nil)
            }
        }
    }
}
