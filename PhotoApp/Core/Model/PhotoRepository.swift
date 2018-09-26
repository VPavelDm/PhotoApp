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
        photo.key = photoDescriptionRef.key
        let photoDescriptionData = photo.toMap()
        compressImage(image: photo.image) { [weak self] imageData in
            self?.sendPhotoImage(description: photoDescriptionData, data: imageData) { [weak self] error in
                if let error = error {
                    callback(nil, error)
                } else {
                    self?.sendPhotoDescription(description: photoDescriptionData) { error in
                        if let error = error {
                            callback(nil, error)
                        } else {
                            callback(photo, error)
                        }
                    }
                }
            }
        }
    }
    
    private func sendPhotoImage(description: [String: Any], data: Data, callback: @escaping (Error?) -> ()) {
        let imageRef = storageRef.child(description[#keyPath(Photo.category)] as! String).child(description[#keyPath(Photo.key)] as! String)
        imageRef.putData(data, metadata: nil) { metadata, error in
            callback(error)
        }
    }
    
    private func sendPhotoDescription(description: [String: Any], callback: @escaping (Error?) -> ()) {
        let photoDescriptionRef = databaseRef.child(description[#keyPath(Photo.key)] as! String)
        photoDescriptionRef.setValue(description, withCompletionBlock: { (error, dbRef) in
            callback(error)
        })
    }
    
    private func compressImage(image: UIImage, callback: @escaping (Data) -> ()) {
        DispatchQueue.global(qos: .userInitiated).async {
            if let imageData = image.compress() {
                DispatchQueue.main.async {
                    callback(imageData)
                }
            }
        }
    }
    
    func update(photo: Photo, callback: @escaping (Photo?, Error?) -> ()) {
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let `self` = self else { return }
            let photoDescriptionRef = self.databaseRef.child(photo.key)
            let photoDescriptionData: [String: Any] = photo.toMap()
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
        databaseRef
            .queryOrdered(byChild: #keyPath(User.uid))
            .queryEqual(toValue: Auth.auth().currentUser!.uid)
            .observeSingleEvent(of: .value) { [weak self] (snapshot) in
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
            let photo = Photo(description: descriptionDictionary, image: image)
            callback(photo)
        }
    }
    
    private func downloadImage(reference imageRef: StorageReference, callback: @escaping (UIImage) -> ()) {
        imageRef.downloadURL(completion: { [weak self] (url, error) in
            if let url = url {
                self?.getData(by: url) { data in
                    if let image = UIImage(data: data) {
                        callback(image)
                    }
                }
            }
        })
    }
    
    private func getData(by url: URL, callback: @escaping (Data) -> ()) {
        DispatchQueue.global(qos: .userInitiated).async {
            if let imageData = try? Data(contentsOf: url) {
                DispatchQueue.main.async {
                    callback(imageData)
                }
            }
        }
    }
}
