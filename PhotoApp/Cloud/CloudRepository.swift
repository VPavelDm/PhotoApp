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
import FirebaseAuth
import MapKit

class CloudRepository {
    
    private static let rootReference = "photos"
    
    private let storageRef: StorageReference
    private let databaseRef: DatabaseReference
    
    init() {
        let user = Auth.auth().currentUser!
        storageRef = Storage.storage().reference().child(CloudRepository.rootReference).child(user.uid)
        databaseRef = Database.database().reference().child(CloudRepository.rootReference).child(user.uid)
    }
    
    func sendPhotoToTheServer(photo: Photo, callback: @escaping (String) -> ()) {
        let photoDescriptionRef = databaseRef.childByAutoId()
        let photoDescriptionData: [String: Any] = [#keyPath(Photo.category): photo.category,
                                                   #keyPath(Photo.date): photo.date,
                                                   #keyPath(Photo.description): photo.photoDescription,
                                                   #keyPath(Photo.latitude): photo.latitude,
                                                   #keyPath(Photo.longitude): photo.longitude]
        photoDescriptionRef.setValue(photoDescriptionData)
        
        let imageRef = storageRef.child(photo.category).child(photoDescriptionRef.key)
        guard let imageData = UIImagePNGRepresentation(photo.image) else { return }
        imageRef.putData(imageData, metadata: nil) { (metadata, error) in
            if let error = error {
                callback(error.localizedDescription)
            }
        }
    }
    
    func getPhotos(categories: [String], callback: @escaping (Photo) -> ()) {
        databaseRef.observeSingleEvent(of: DataEventType.value) { [weak self] (snapshot) in
            for idSnapshot in snapshot.children {
                if let idSnapshot = idSnapshot as? DataSnapshot, let photoDescriptionDictionary = idSnapshot.value as? [String: Any] {
                    guard
                        let `self` = self,
                        let photoLatitude = photoDescriptionDictionary[#keyPath(Photo.latitude)] as? Double,
                        let photoLongitude = photoDescriptionDictionary[#keyPath(Photo.longitude)] as? Double,
                        let photoCategory = photoDescriptionDictionary[#keyPath(Photo.category)] as? String,
                        let photoDate = photoDescriptionDictionary[#keyPath(Photo.date)] as? String,
                        let photoDescription = photoDescriptionDictionary[#keyPath(Photo.description)] as? String else { return }
                    
                    if categories.contains(photoCategory) {
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
