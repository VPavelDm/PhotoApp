//
//  MapViewControllerImagePickerDelegate.swift
//  PhotoApp
//
//  Created by mac-089-71 on 9/7/18.
//  Copyright © 2018 VPavelDm. All rights reserved.
//

import Foundation
import UIKit

extension MapViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func showImagePicker(source: UIImagePickerControllerSourceType) {
        if UIImagePickerController.isSourceTypeAvailable(source) {
            let imagePicker = UIImagePickerController()
            imagePicker.sourceType = source
            imagePicker.allowsEditing = false
            imagePicker.delegate = self
            present(imagePicker, animated: true, completion: nil)
        } else {
            showAlertWithError(message: NSLocalizedString("The \(source == .camera ? "Camera" : "PhotoLibrary") is not available on this device", comment: "Message that indicates that source is not available"))
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        let photoPopupViewController = PhotoPopupViewController.create(asClass: PhotoPopupViewController.self)
        let photo = Photo(coordinate: CoordinationManager.manager.getLastCoordinate(), image: image)
        photoPopupViewController.photo = photo
        photoPopupViewController.delegate = self
        picker.dismiss(animated: true, completion: nil)
        self.present(photoPopupViewController, animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }

}
