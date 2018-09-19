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
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var modeButton: UIButton!
    
    @IBAction func clickCameraBtn(_ sender: UIButton) {
        locationManager.checkLocationService { [weak self] (status) in
            guard let `self` = self else { return }
            switch status {
            case .authorized:
                self.lastKnownCoordinates = self.locationManager.coordinate
                self.startActionSheetsToTakeAPicture()
            case .denied:
                self.presentLocationSettings()
            case .error:
                let alert = UIAlertController(message: NSLocalizedString("Location servicies are not enabled", comment: ""))
                self.present(alert, animated: true)
            }
        }
    }
    
    @IBAction func longClickOnMap(_ sender: UILongPressGestureRecognizer) {
        switch sender.state {
        case .began:
            let touchLocation = sender.location(in: mapView)
            lastKnownCoordinates = mapView.convert(touchLocation, toCoordinateFrom: mapView)
            startActionSheetsToTakeAPicture()
        default:
            break
        }
    }
    
    @IBAction func clickChangeModeButton(_ sender: UIButton) {
        if mapView.userTrackingMode == .none {
            mapView.userTrackingMode = .followWithHeading
        } else {
            mapView.userTrackingMode = .none
        }
    }
    
    @IBAction func clickCategoryButton(_ sender: UIButton) {
        let categoryViewController = CategoryTableViewController.create(storyboardId: "categoryTableViewController", asClass: CategoryTableViewController.self)
        categoryViewController.delegate = self
        categoryViewController.selectedCategories = categories
        let navigationViewController = UINavigationController(rootViewController: categoryViewController)
        present(navigationViewController, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        photoDataProvider.delegate = self
        let defaults = UserDefaults.standard
        categories = Category.convert(categories: defaults.array(forKey: String(describing: Category.self)) as? [String]) ?? Category.getAll()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        locationManager.checkLocationService { [weak self] (status) in
            switch status {
            case .authorized:
                self?.mapView.userTrackingMode = .followWithHeading
            case .denied:
                self?.mapView.userTrackingMode = .none
                self?.presentLocationSettings()
            case .error:
                let alert = UIAlertController(message: NSLocalizedString("Location servicies are not enabled", comment: ""))
                self?.present(alert, animated: true)
            }
        }
    }
    
    let locationManager = LocationService()
    let photoDataProvider = MapPhotoDataProvider()
    var categories: [Category]! {
        didSet {
            mapView.removeAnnotations(mapView.annotations)
            photoDataProvider.categories = categories
        }
    }
    var lastKnownCoordinates: CLLocationCoordinate2D!
    var photoImage: UIImage? {
        didSet {
            guard
                let coordinates = lastKnownCoordinates,
                let image = photoImage else {
                    let alert = UIAlertController(message: NSLocalizedString("Application can't get user location coordinates, try to turn on location permission or add photo by long press on map", comment: "Error message"))
                    present(alert, animated: true)
                    return
            }
            let photoPopupViewController = PhotoModificationViewController.create(asClass: PhotoModificationViewController.self)
            photoPopupViewController.delegate = self
            let photo = Photo(coordinate: coordinates, image: image)
            photoPopupViewController.photo = photo
            
            present(photoPopupViewController, animated: true, completion: nil)
            lastKnownCoordinates = nil
            photoImage = nil
        }
    }
    
    private func presentLocationSettings() {
        let alertController = UIAlertController(title: "Error",
                                                message: "Location access is denied",
                                                preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Cancel", style: .default))
        alertController.addAction(UIAlertAction(title: "Settings", style: .cancel) { _ in
            UIApplication.shared.openURL(URL(string: UIApplication.openSettingsURLString)!)
        })
        
        present(alertController, animated: true)
    }
    
}
