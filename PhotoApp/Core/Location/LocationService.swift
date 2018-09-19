//
//  LocationService.swift
//  PhotoApp
//
//  Created by mac-089-71 on 9/19/18.
//  Copyright © 2018 VPavelDm. All rights reserved.
//

import Foundation
import MapKit

class LocationService: NSObject, CLLocationManagerDelegate {
    
    private let locationManager = CLLocationManager()
    private var callback: ((LocationStatus) -> ())?
    
    var coordinate: CLLocationCoordinate2D? {
        return locationManager.location?.coordinate
    }
    
    func checkLocationService(callback: @escaping (LocationStatus) -> ()) {
        self.callback = callback
        if CLLocationManager.locationServicesEnabled() {
            setupLocationManager()
            checkAuthorization()
        } else {
            callback(.error)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkAuthorization()
    }
    
    private func setupLocationManager() {
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.delegate = self
    }

    private func checkAuthorization() {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse:
            callback?(.authorized)
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .denied:
            callback?(.denied)
        default:
            break
        }
    }
    
}
