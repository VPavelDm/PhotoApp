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
    
    private var lastKnownCoordinate: CLLocationCoordinate2D?
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        mapView.delegate = self
    }
    
    @IBAction func clickCameraBtn(_ sender: UIButton) {
        // MARK: get user coordinate and call startActionSheetsToTakeAPicture
    }
    
    @IBAction func longClickOnMap(_ sender: UILongPressGestureRecognizer) {
        switch sender.state {
        case .began:
            let touchLocation = sender.location(in: mapView)
            let locationCoordinate = mapView.convert(touchLocation, toCoordinateFrom: mapView)
            lastKnownCoordinate = locationCoordinate
            startActionSheetsToTakeAPicture()
        default:
            break
        }
    }
    
    private func startActionSheetsToTakeAPicture(){
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
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        let photoPopupViewController = PhotoPopupViewController.create(asClass: PhotoPopupViewController.self)
        photoPopupViewController.image = image
        photoPopupViewController.delegate = self
        picker.dismiss(animated: true, completion: nil)
        self.present(photoPopupViewController, animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}

extension MapViewController: PhotoPopupDelegate {
    func savePhoto(photo: Photo) {
        if let coordinate = lastKnownCoordinate {
            mapView.addAnnotation(MarkerAnnotation.createMarker(by: photo, coordinate: coordinate))
            let cloud = CloudRepository()
            cloud.sendPhoto(photo: photo)
        }
    }
}

extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let annotation = annotation as? MarkerAnnotation else {
            return nil
        }
        let annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: annotation.category)
        //MARK: Add choosing between different markers
        annotationView.image = UIImage(named: "marker_nature")
        annotationView.rightCalloutAccessoryView = UIButton(type: .infoDark)
        let photoDetail = PhotoDetailView()
        photoDetail.dateLabel.text = annotation.date
        photoDetail.descriptionLabel.text = annotation.photoDescription
        annotationView.detailCalloutAccessoryView = photoDetail
        let annotationImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: annotationView.frame.height + 16, height: annotationView.frame.height + 16))
        annotationImageView.image = annotation.image!
        annotationImageView.contentMode = .scaleAspectFill
        annotationView.leftCalloutAccessoryView = annotationImageView
        annotationView.canShowCallout = true
        return annotationView
    }
}
