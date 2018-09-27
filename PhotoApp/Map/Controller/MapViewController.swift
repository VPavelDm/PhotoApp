//
//  MapViewController.swift
//  PhotoApp
//
//  Created by mac-089-71 on 8/30/18.
//  Copyright © 2018 VPavelDm. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: ViewController {
    
    @IBOutlet private weak var mapView: MKMapView! {
        didSet {
            mapView.delegate = self
        }
    }
    @IBOutlet private weak var modeButton: UIButton!
    
    @IBAction private func clickCameraBtn(_ sender: UIButton) {
        locationManager.checkLocationService { [weak self] (status) in
            guard let `self` = self else { return }
            switch status {
            case .authorized:
                self.lastKnownCoordinates = self.locationManager.coordinate
                self.startActionSheetsToTakeAPicture()
            case .denied:
                self.presentLocationSettings()
            case .error:
                let alert = UIAlertController(message: "Location servicies are not enabled".localized())
                self.present(alert, animated: true)
            }
        }
    }
    
    @IBAction private func longClickOnMap(_ sender: UILongPressGestureRecognizer) {
        switch sender.state {
        case .began:
            let touchLocation = sender.location(in: mapView)
            lastKnownCoordinates = mapView.convert(touchLocation, toCoordinateFrom: mapView)
            startActionSheetsToTakeAPicture()
        default:
            break
        }
    }
    
    @IBAction private func clickChangeModeButton(_ sender: UIButton) {
        if mapView.userTrackingMode == .none {
            mapView.userTrackingMode = .followWithHeading
        } else {
            mapView.userTrackingMode = .none
        }
    }
    
    @IBAction private func clickCategoryButton(_ sender: UIButton) {
        let categoryViewController = CategoryTableViewController.createController(asClass: CategoryTableViewController.self)
        categoryViewController.delegate = self
        categoryViewController.selectedCategories = categories
        let navigationViewController = UINavigationController(rootViewController: categoryViewController)
        present(navigationViewController, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.startAnimating()
        let defaults = UserDefaults.standard
        categories = Category.convert(categories: defaults.array(forKey: String(describing: Category.self)) as? [String]) ?? Category.getAll()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        locationManager.checkLocationService { [weak self] (status) in
            switch status {
            case .authorized:
                self?.mapView.showsUserLocation = true
                self?.mapView.userTrackingMode = .followWithHeading
            case .denied:
                self?.mapView.userTrackingMode = .none
                self?.presentLocationSettings()
            case .error:
                let alert = UIAlertController(message: "Location servicies are not enabled".localized())
                self?.present(alert, animated: true)
            }
        }
    }
    
    private let locationManager = LocationService()
    private let photoDataProvider = MapPhotoDataProvider()
    var categories: [Category]! {
        didSet {
            activityIndicator?.startAnimating()
            mapView.removeAnnotations(mapView.annotations)
            photoDataProvider.delegate = self
            photoDataProvider.categories = categories
        }
    }
    private var lastKnownCoordinates: CLLocationCoordinate2D!
    private var photoImage: UIImage? {
        didSet {
            guard
                let coordinates = lastKnownCoordinates,
                let image = photoImage else {
                    let alert = UIAlertController(message: "Application can't get user location coordinates, try to turn on location permission or add photo by long press on map".localized())
                    present(alert, animated: true)
                    return
            }
            let photo = Photo(coordinate: coordinates, image: image)
            let photoPopupViewController = PhotoModificationViewController.createController(photo: photo, delegate: self)
            
            present(photoPopupViewController, animated: true, completion: nil)
            lastKnownCoordinates = nil
            photoImage = nil
        }
    }
    
    private func presentLocationSettings() {
        let alertController = UIAlertController(title: "Error".localized(),
                                                message: "Location access is denied".localized(),
                                                preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Cancel".localized(), style: .default))
        alertController.addAction(UIAlertAction(title: "Settings".localized(), style: .cancel) { _ in
            UIApplication.shared.openURL(URL(string: UIApplication.openSettingsURLString)!)
        })
        
        present(alertController, animated: true)
    }
    
    private func startActionSheetsToTakeAPicture() {
        
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let takePictureAction = UIAlertAction(title: "Take a Picture".localized(), style: .default) { [weak self] action in
            self?.showImagePicker(source: .camera)
        }
        let chooseFromLibraryAction = UIAlertAction(title: "Choose From Library".localized(), style: .default) { [weak self] action in
            self?.showImagePicker(source: .photoLibrary)
        }
        let cancelAction = UIAlertAction(title: "Cancel".localized(), style: .cancel) { [weak self] (action) in
            self?.lastKnownCoordinates = nil
        }
        
        alert.addAction(takePictureAction)
        alert.addAction(chooseFromLibraryAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
    }
    
}

extension MapViewController: MKMapViewDelegate, PhotoDetailDelegate {
    
    private func addAnnotation(photo: Photo) {
        if categories.contains(Category(rawValue: photo.category)!){
            mapView.addAnnotation(photo)
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let annotation = annotation as? Photo else {
            return nil
        }
        let annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: annotation.category)
        annotationView.image = getMarkerPin(by: Category(rawValue: annotation.category)!)
        let photoDetail = PhotoDetailView(photo: annotation, delegate: self)        
        annotationView.detailCalloutAccessoryView = photoDetail
        annotationView.canShowCallout = true
        return annotationView
    }
    
    func clickedMarker(photo: Photo) {
        let viewController = PhotoModificationViewController.createController(photo: photo, delegate: self)
        for annotation in mapView.selectedAnnotations {
            mapView.deselectAnnotation(annotation, animated: true)
        }
        present(viewController, animated: true)
    }
    
    func mapView(_ mapView: MKMapView, didChange mode: MKUserTrackingMode, animated: Bool) {
        if mode == .none {
            modeButton.setImage(UIImage(named: "ic_center_on_me_disable"), for: .normal)
        } else {
            modeButton.setImage(UIImage(named: "ic_center_on_me_selected"), for: .normal)
        }
    }
    
    private func getMarkerPin(by category: Category) -> UIImage {
        let imageName: String
        switch category {
        case .nature:
            imageName = "marker_nature"
        case .friends:
            imageName = "marker_friends"
        case .default_category:
            imageName = "marker_default"
        }
        return UIImage(named: imageName)!
    }
}

extension MapViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    private func showImagePicker(source: UIImagePickerController.SourceType) {
        if UIImagePickerController.isSourceTypeAvailable(source) {
            let imagePicker = UIImagePickerController()
            imagePicker.sourceType = source
            imagePicker.allowsEditing = false
            imagePicker.delegate = self
            present(imagePicker, animated: true, completion: nil)
        } else {
            let alert = UIAlertController(message: "The \(source == .camera ? "Camera" : "PhotoLibrary") is not available on this device".localized())
            present(alert, animated: true)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // Local variable inserted by Swift 4.2 migrator.
        let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)
        
        picker.dismiss(animated: true, completion: nil)
        photoImage = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.originalImage)] as? UIImage
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
    return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
    return input.rawValue
}

extension MapViewController: CategoryDelegate {
    func choosed(categories: [Category]) {
        self.categories = categories
    }
}

extension MapViewController: PhotoPopupDelegate {
    
    func photoAdded(photo: Photo) {
        if categories.contains(Category(rawValue: photo.category)!){
            addAnnotation(photo: photo)
        }
    }
    
    func photoUpdated(photo: Photo) {
        for annotation in mapView.annotations {
            guard let annotation = annotation as? Photo else { continue }
            if annotation == photo {
                mapView.removeAnnotation(annotation)
                break
            }
        }
        photoAdded(photo: photo)
    }
    
    func didReceivedError(error: Error) {
        let alert = UIAlertController(message: error.localizedDescription)
        present(alert, animated: true)
    }
}

extension MapViewController: MapPhotoDataProviderDelegate {
    func didReceivedPhotos(photos: [Photo]) {
        activityIndicator.stopAnimating()
        mapView.removeAnnotations(mapView.annotations)
        for photo in photos {
            addAnnotation(photo: photo)
        }
    }
}
