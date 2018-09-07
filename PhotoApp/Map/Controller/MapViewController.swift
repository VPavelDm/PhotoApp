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
    
    override func viewDidLoad() {
        mapView.delegate = self
        DispatchQueue.global(qos: .userInitiated).async {
            CloudRepository.cloud.getPhotos{ (photo) in
                DispatchQueue.main.async { [weak self] () in
                    self?.addAnnotation(photo: photo)
                }
            }
        }
    }
    
    @IBAction func clickCameraBtn(_ sender: UIButton) {
        // MARK: get user coordinate and call startActionSheetsToTakeAPicture
    }
    
    @IBAction func longClickOnMap(_ sender: UILongPressGestureRecognizer) {
        switch sender.state {
        case .began:
            let touchLocation = sender.location(in: mapView)
            let locationCoordinate = mapView.convert(touchLocation, toCoordinateFrom: mapView)
            CoordinationManager.manager.sendCoordinate(locationCoordinate)
            startActionSheetsToTakeAPicture()
        default:
            break
        }
    }
    
    
    
}
