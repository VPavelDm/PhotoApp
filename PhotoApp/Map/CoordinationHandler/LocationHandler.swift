//
//  PhotoLocationHandler.swift
//  PhotoApp
//
//  Created by mac-089-71 on 9/10/18.
//  Copyright © 2018 VPavelDm. All rights reserved.
//

import Foundation
import MapKit

class LocationHandler: NSObject, CLLocationManagerDelegate {
    
    private let errorCallback: (String) -> ()
    private let coordinatesCallback: (CLLocationCoordinate2D) -> ()
    
    init(coordinatesCallback: @escaping (CLLocationCoordinate2D) -> (), errorCallback: @escaping (String) -> ()) {
        self.errorCallback = errorCallback
        self.coordinatesCallback = coordinatesCallback
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        errorCallback(error.localizedDescription)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let coordinates = locations.last?.coordinate {
            coordinatesCallback(coordinates)
        }
    }
    
}
