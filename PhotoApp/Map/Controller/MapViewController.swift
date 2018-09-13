//
//  MapViewController.swift
//  PhotoApp
//
//  Created by mac-089-71 on 8/30/18.
//  Copyright © 2018 VPavelDm. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: ViewController, CloudRepositoryDelegate {
    func photo(photo: Photo) {
        addAnnotation(photo: photo)
    }
    
    func error(message error: String) {
        showAlertWithError(message: error)
    }
    
    @IBOutlet weak var mapView: MKMapView! {
        didSet {
            mapView.showsUserLocation = true
            mapView.userTrackingMode = .followWithHeading
        }
    }
    @IBOutlet weak var modeButton: UIButton!
    
    private let locationManager = CLLocationManager()
    private let cloud = CloudRepository()
    
    var categories: [Category]! {
        didSet {
            mapView.removeAnnotations(annotations)
            annotations = []
            cloud.subscribeToUpdatePhotos(categories: categories)
        }
    }
    var lastKnownCoordinates: CLLocationCoordinate2D? {
        didSet {
            guard
                let lastKnownCoordinates = lastKnownCoordinates,
                let photoImage = photoImage
                else { return }
            let photoPopupViewController = PhotoPopupViewController.create(asClass: PhotoPopupViewController.self)
            let photo = Photo(coordinate: lastKnownCoordinates, image: photoImage)
            photoPopupViewController.photo = photo
            photoPopupViewController.delegate = self
            self.present(photoPopupViewController, animated: true, completion: nil)
            self.photoImage = nil
            self.lastKnownCoordinates = nil
        }
    }
    var photoImage: UIImage? {
        didSet {
            if photoImage != nil {
                (lastKnownCoordinates = lastKnownCoordinates)
            }
        }
    }
    var annotations: [Photo] = []
    
    override func viewDidLoad() {
        mapView.delegate = self
        categories = Category.getAll()
    }
    
    @IBAction func clickCameraBtn(_ sender: UIButton) {

        if CLLocationManager.locationServicesEnabled() {
            startActionSheetsToTakeAPicture()
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestLocation()
            locationManager.startUpdatingLocation()
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
        let textAttributes = [NSAttributedStringKey.foregroundColor: sender.tintColor!]
        navigationViewController.navigationBar.titleTextAttributes = textAttributes
        present(navigationViewController, animated: true)
    }
    
}
