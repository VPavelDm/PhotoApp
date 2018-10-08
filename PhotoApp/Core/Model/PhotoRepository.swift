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
    private lazy var user = Auth.auth().currentUser!
    private let internetService = InternetService()
    
    init() {
        storageRef = Storage.storage().reference().child(PhotoRepository.rootReference)
        databaseRef = Database.database().reference().child(PhotoRepository.rootReference)
    }

    func create(photo: Photo, image: UIImage, callback: @escaping (Photo?, Error?) -> ()) {
        //Create node in the realtime database
        let photoDescriptionRef = databaseRef.childByAutoId()
        //Save the key to be able to update this node
        photo.key = photoDescriptionRef.key
        internetService.isReachability { [weak self] (error) in
            if let error = error {
                callback(nil, error)
            } else {
                self?.compressImage(image: image) { [weak self] imageData in
                    self?.save(photo: photo, data: imageData, callback: callback)
                }
            }
        }
    }
    
    private func save(photo: Photo, data: Data, callback: @escaping (Photo?, Error?) -> ()) {
        let key = photo.toMap()[#keyPath(Photo.key)] as! String
        //Save image with the name that equals to the photo description key to identify the image
        let imageRef = storageRef.child(user.uid).child(key)
        imageRef.putData(data, metadata: nil) { [weak self] _, error in
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
        photoDescriptionRef.setValue(description, withCompletionBlock: { (error, _) in
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
    
    func update(photo: Photo, callback: @escaping (Photo?, Error?) -> ()) {
        let photoDescriptionRef = self.databaseRef.child(photo.key)
        let photoDescriptionData: [String: Any] = photo.toMap()
        internetService.isReachability { (error) in
            if let error = error {
                callback(nil, error)
            } else {
                photoDescriptionRef.setValue(photoDescriptionData) { (error, dbRef) in
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
        internetService.isReachability { [weak self] (error) in
            if let error = error {
                callback(nil, error)
            } else {
                self?.sendRequestToGetPhotos(callback: callback)
            }
        }
    }
    
    private func sendRequestToGetPhotos(callback: @escaping ([Photo]?, Error?) -> ()) {
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
    
    private func isConnected(completion: @escaping (Bool) -> ()) {
        let connectedRef = Database.database().reference(withPath: ".info/connected")
        connectedRef.observeSingleEvent(of: .value) { (snapshot) in
            if snapshot.value as? Bool ?? false {
                completion(true)
            } else {
                completion(false)
            }
        }
    }
    
    private func createPhoto(key: String, descriptionDictionary: [String: Any], callback: @escaping (Photo) -> ()) {
        let imageRef = self.storageRef.child(user.uid).child(key)
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
