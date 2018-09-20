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

class PhotoRepository {
    
    private static let rootReference = "photos"
    
    private let storageRef: StorageReference
    private let databaseRef: DatabaseReference
    
    init() {
        storageRef = Storage.storage().reference().child(PhotoRepository.rootReference)
        databaseRef = Database.database().reference().child(PhotoRepository.rootReference)
    }

    func create(photo: Photo, callback: @escaping (Photo?, Error?) -> ()) {
        let photoDescriptionRef = databaseRef.childByAutoId()
        let photoDescriptionData = photo.toMap(key: photoDescriptionRef.key)
        let imageRef = storageRef.child(photo.category).child(photoDescriptionRef.key)
        DispatchQueue.global(qos: .userInitiated).async {
            guard let imageData = photo.image.pngData() else { return }
            DispatchQueue.main.async {
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
        }
    }
    
    func update(photo: Photo, callback: @escaping (Photo?, Error?) -> ()) {
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let `self` = self else { return }
            let photoDescriptionRef = self.databaseRef.child(photo.key)
            let photoDescriptionData: [String: Any] = photo.toMap(key: photo.key)
            photoDescriptionRef.setValue(photoDescriptionData) { (error, dbRef) in
                DispatchQueue.main.async {
                    if let error = error {
                        callback(nil, error)
                    } else {
                        callback(photo, error)
                    }
                }
            }
        }
    }
    
    func getPhotos(callback: @escaping ([Photo]?, Error?) -> ()) {
        var photos: [Photo] = []
        databaseRef.queryOrdered(byChild: #keyPath(User.uid)).queryEqual(toValue: Auth.auth().currentUser!.uid).observeSingleEvent(of: .value) { [weak self] (snapshot) in
            if snapshot.childrenCount == 0 {
                callback(photos, nil)
            }
            for photoSnapshot in snapshot.children {
                if let photoSnapshot = photoSnapshot as? DataSnapshot, let photoDescriptionDictionary = photoSnapshot.value as? [String: Any] {
                    self?.createPhoto(key: photoSnapshot.key, descriptionDictionary: photoDescriptionDictionary, callback: { (photo) in
                        photos += [photo]
                        if photos.count == snapshot.childrenCount {
                            callback(photos, nil)
                        }
                    })
                }
            }
        }
    }
    
    private func createPhoto(key: String, descriptionDictionary: [String: Any], callback: @escaping (Photo) -> ()) {
        let photoCategory = descriptionDictionary[#keyPath(Photo.category)] as! String
        let imageRef = self.storageRef.child(photoCategory).child(key)
        self.downloadImage(reference: imageRef) { image in
            let photo = descriptionDictionary.createPhoto(image: image)
            callback(photo)
        }
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
