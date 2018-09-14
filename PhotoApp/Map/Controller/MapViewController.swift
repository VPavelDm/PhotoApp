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
            mapView.userTrackingMode = .followWithHeading
        }
    }
    @IBOutlet weak var modeButton: UIButton!
    
    @IBAction func clickCameraBtn(_ sender: UIButton) {
        checkLocationServicies()
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
        categories = Category.getAll()
    }
    
    let locationManager = CLLocationManager()
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
            let photoPopupViewController = PhotoPopupViewController.create(asClass: PhotoPopupViewController.self)
            let photo = Photo(coordinate: coordinates, image: image)
            photoPopupViewController.photo = photo
            
            present(photoPopupViewController, animated: true, completion: nil)
            lastKnownCoordinates = nil
            photoImage = nil
        }
    }
    
}
