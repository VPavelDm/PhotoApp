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

    func create(photo: Photo, image: UIImage, callback: @escaping (Photo?, Error?) -> ()) {
        let photoDescriptionRef = databaseRef.childByAutoId()
        photo.key = photoDescriptionRef.key
        compressImage(image: image) { [weak self] imageData in
            self?.sendPhotoImage(photo: photo, data: imageData, callback: callback)
        }
    }
    
    private func sendPhotoImage(photo: Photo, data: Data, callback: @escaping (Photo?, Error?) -> ()) {
        let key = photo.toMap()[#keyPath(Photo.key)] as! String
        let user = Auth.auth().currentUser!
        let imageRef = storageRef.child(user.uid).child(key)
        imageRef.putData(data, metadata: nil) { [weak self] metadata, error in
            if let error = error {
                callback(nil, error)
            } else {
                imageRef.downloadURL(completion: { (url, error) in
                    if let error = error {
                        callback(nil, error)
                    } else if let url = url {
                        photo.url = url
                        self?.sendPhotoDescription(photo: photo, callback: callback)
                    }
                })
            }
        }
    }
    
    private func sendPhotoDescription(photo: Photo, callback: @escaping (Photo?, Error?) -> ()) {
        let description = photo.toMap()
        let key = description[#keyPath(Photo.key)] as! String
        let photoDescriptionRef = databaseRef.child(key)
        photoDescriptionRef.setValue(description, withCompletionBlock: { (error, dbRef) in
            if let error = error {
                callback(nil, error)
            } else {
                callback(photo, error)
            }
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
    
    // MARK: Check threads
    func update(photo: Photo, callback: @escaping (Photo?, Error?) -> ()) {
        let photoDescriptionRef = self.databaseRef.child(photo.key)
        let photoDescriptionData: [String: Any] = photo.toMap()
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
        let user = Auth.auth().currentUser
        let imageRef = self.storageRef.child(user!.uid).child(key)
        var descriptionDictionary = descriptionDictionary
        self.downloadUrl(reference: imageRef) { url in
            descriptionDictionary[#keyPath(Photo.url)] = url
            let photo = Photo(description: descriptionDictionary)
            callback(photo)
        }
    }
    
    private func downloadUrl(reference imageRef: StorageReference, callback: @escaping (URL) -> ()) {
        imageRef.downloadURL(completion: { (url, error) in
            if let url = url {
                callback(url)
            }
        })
    }
}
