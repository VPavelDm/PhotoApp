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

    func create(photo: Photo, callback: @escaping (Photo?, Error?) -> ()) {
        let photoDescriptionRef = databaseRef.childByAutoId()
        photo.key = photoDescriptionRef.key
        let photoDescriptionData: [String: Any] = [#keyPath(Photo.key): photo.key,
                                                   #keyPath(Photo.category): photo.category,
                                                   #keyPath(Photo.date): photo.date,
                                                   #keyPath(Photo.description): photo.photoDescription,
                                                   #keyPath(Photo.latitude): photo.latitude,
                                                   #keyPath(Photo.longitude): photo.longitude]
        let imageRef = storageRef.child(photo.category).child(photoDescriptionRef.key)
        guard let imageData = photo.image.pngData() else { return }
        imageRef.putData(imageData, metadata: nil) { (metadata, error) in
            if let error = error {
                callback(nil, error)
            } else {
                photoDescriptionRef.setValue(photoDescriptionData, withCompletionBlock: { (error, dbRef) in
                    if let error = error {
                        callback(nil, error)
                    } else {
                        callback(photo, error)
                    }
                })
            }
        }
    }
    
    func update(photo: Photo, callback: @escaping (Photo?, Error?) -> ()) {
        let photoDescriptionRef = databaseRef.child(photo.key)
        let photoDescriptionData: [String: Any] = [#keyPath(Photo.category): photo.category,
                                                   #keyPath(Photo.date): photo.date,
                                                   #keyPath(Photo.description): photo.photoDescription,
                                                   #keyPath(Photo.latitude): photo.latitude,
                                                   #keyPath(Photo.longitude): photo.longitude]
        photoDescriptionRef.setValue(photoDescriptionData) { (error, dbRef) in
            if let error = error {
                callback(nil, error)
            } else {
                callback(photo, error)
            }
        }
    }
    
    func getPhotos(callback: @escaping ([Photo]?, Error?) -> ()) {
        var photos: [Photo] = []
        databaseRef.observeSingleEvent(of: .value) { (snapshot) in
            for photoSnapshot in snapshot.children {
                if let photoSnapshot = photoSnapshot as? DataSnapshot, var photoDescriptionDictionary = photoSnapshot.value as? [String: Any] {
                    guard let photoCategory = photoDescriptionDictionary[#keyPath(Photo.category)] as? String else { return }
                    photoDescriptionDictionary["key"] = photoSnapshot.key
                    let imageRef = self.storageRef.child(photoCategory).child(photoSnapshot.key)
                    self.downloadImage(reference: imageRef) { [weak self] image in
                        photoDescriptionDictionary[#keyPath(Photo.image)] = image
                        guard let photo = self?.createPhotoByDescriptionMap(map: photoDescriptionDictionary) else { return }
                        photos += [photo]
                        if photos.count == snapshot.childrenCount {
                            callback(photos, nil)
                        }
                    }
                }
            }
        }
    }
    
    private func createPhotoByDescriptionMap(map photoDescriptionDictionary: [String: Any]) -> Photo? {
        guard
            let photoLatitude = photoDescriptionDictionary[#keyPath(Photo.latitude)] as? Double,
            let photoLongitude = photoDescriptionDictionary[#keyPath(Photo.longitude)] as? Double,
            let photoCategory = photoDescriptionDictionary[#keyPath(Photo.category)] as? String,
            let photoDate = photoDescriptionDictionary[#keyPath(Photo.date)] as? String,
            let photoDescription = photoDescriptionDictionary[#keyPath(Photo.description)] as? String,
            let image = photoDescriptionDictionary[#keyPath(Photo.image)] as? UIImage,
            let key = photoDescriptionDictionary["key"] as? String
            else { return nil }
        let coordinate = CLLocationCoordinate2D(latitude: photoLatitude, longitude: photoLongitude)
        return Photo(key: key, description: photoDescription, category: photoCategory, date: photoDate, image: image, coordinate: coordinate)
    }
    
    private func downloadImage(reference imageRef: StorageReference, callback: @escaping (UIImage) -> ()) {
        imageRef.downloadTestURL(completion: { (url, error) in
            guard let url = url else { return }
            DispatchQueue.global(qos: .userInitiated).async {
                if let imageData = try? Data(contentsOf: url) {
                    guard let image = UIImage(data: imageData) else { return }
                    DispatchQueue.main.async {
                        callback(image)
                    }
                }
            }
        })
    }
}

extension StorageReference {
    func downloadTestURL(completion: @escaping (_ url: URL?, _ error: Error?) -> ()) {
        DispatchQueue.global(qos: .userInitiated).async {
            DispatchQueue.main.async {
                completion(URL(string: "https://sobaki.guru/wp-content/uploads/2018/01/siba_inu_29_19121837.jpg"), nil)
            }
        }
    }
}
