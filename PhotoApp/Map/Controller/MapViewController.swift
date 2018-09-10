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
        }
    }
    @IBOutlet weak var modeButton: UIButton!
    
    private let locationManager = CLLocationManager()
    
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
    
    private let cloud = CloudRepository()
    
    override func viewDidLoad() {
        mapView.delegate = self
        mapView.userTrackingMode = .followWithHeading
        cloud.getPhotos{ [weak self] (photo) in
            self?.addAnnotation(photo: photo)
        }
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
        // 0 - Not select on me button mode
        // 1 - Select on me button mode
        if sender.tag == 1 {
            mapView.userTrackingMode = .none
        } else {
            mapView.userTrackingMode = .followWithHeading
        }
        sender.tag = (sender.tag + 1) % 2 // Change button tag to another mode
    }
    
}
