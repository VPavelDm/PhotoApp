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
    
    @IBOutlet weak var mapView: MKMapView! {
        didSet {
            mapView.showsUserLocation = true
            mapView.userTrackingMode = .followWithHeading
        }
    }
    @IBOutlet weak var modeButton: UIButton!
    
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
        present(navigationViewController, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        photoManager.delegate = self
        categories = Category.getAll()
    }
    
    private let locationManager = CLLocationManager()
    
    let photoManager = PhotoManager()
    var categories: [Category]! {
        didSet {
            mapView.removeAnnotations(photoManager.getPhotos(monthAndYear: nil))
            photoManager.categories = categories
        }
    }
    var lastKnownCoordinates: CLLocationCoordinate2D? {
        didSet {
            guard
                let coordinates = lastKnownCoordinates,
                let image = photoImage
                else { return }
            let photoPopupViewController = PhotoPopupViewController.create(asClass: PhotoPopupViewController.self)
            let photo = Photo(coordinate: coordinates, image: image)
            photoPopupViewController.photo = photo
            photoPopupViewController.delegate = self
            
            present(photoPopupViewController, animated: true, completion: nil)
            
            photoImage = nil
            lastKnownCoordinates = nil
        }
    }
    var photoImage: UIImage? {
        didSet {
            if photoImage != nil {
                (lastKnownCoordinates = lastKnownCoordinates)
            }
        }
    }
    
}
