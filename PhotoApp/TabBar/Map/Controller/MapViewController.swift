//
//  MapViewController.swift
//  PhotoApp
//
//  Created by mac-089-71 on 8/30/18.
//  Copyright © 2018 VPavelDm. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: ViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    
    @IBAction func clickCameraBtn(_ sender: UIButton) {
        // MARK: get user coordinate and call startActionSheetsToTakeAPicture
    }
    
    @IBAction func longClickOnMap(_ sender: UILongPressGestureRecognizer) {
        switch sender.state {
        case .began:
            let touchLocation = sender.location(in: mapView)
            let locationCoordinate = mapView.convert(touchLocation, toCoordinateFrom: mapView)
            startActionSheetsToTakeAPicture(at: locationCoordinate)
        default:
            break
        }
    }
    
    private func startActionSheetsToTakeAPicture(at position: CLLocationCoordinate2D){
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let takePictureAction = UIAlertAction(title: NSLocalizedString("Take a Picture", comment: "Take a Picture label"), style: .default) { [weak self] action in
            self?.showImagePicker(source: .camera)
        }
        let chooseFromLibraryAction = UIAlertAction(title: NSLocalizedString("Choose From Library", comment: "Choose From Library label"), style: .default) { [weak self] action in
            self?.showImagePicker(source: .photoLibrary)
        }
        let cancelAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: "Cancel label"), style: .cancel, handler: nil)
        
        alert.addAction(takePictureAction)
        alert.addAction(chooseFromLibraryAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
    }
    
    private func showImagePicker(source: UIImagePickerControllerSourceType) {
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
}

extension MapViewController {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        print("Hello, world!")
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
