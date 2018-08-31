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
        
        let takePictureAction = UIAlertAction(title: "Take a Picture", style: .default) { action in
            // MARK: Run camera, take picture and add annotation to the map with coordinates
        }
        let chooseFromLibraryAction = UIAlertAction(title: "Choose From Library", style: .default) { action in
            // MARK: Take a picture from the library and add annotation to the map with coordinates
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(takePictureAction)
        alert.addAction(chooseFromLibraryAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
    }
}
