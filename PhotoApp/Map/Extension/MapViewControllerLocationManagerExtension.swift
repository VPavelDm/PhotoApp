//
//  MapViewControllerLocationManagerExtension.swift
//  PhotoApp
//
//  Created by mac-089-71 on 9/10/18.
//  Copyright © 2018 VPavelDm. All rights reserved.
//

import Foundation
import MapKit

extension MapViewController : CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        showAlertWithError(message: error.localizedDescription)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let coordinates = locations.last?.coordinate {
            if lastKnownCoordinates == nil {
                lastKnownCoordinates = coordinates
            }
        }
    }
    
}
