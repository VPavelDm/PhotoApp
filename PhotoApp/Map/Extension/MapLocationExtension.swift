//
//  MapLocationExtension.swift
//  PhotoApp
//
//  Created by mac-089-71 on 9/13/18.
//  Copyright © 2018 VPavelDm. All rights reserved.
//

import Foundation
import MapKit

extension MapViewController: CLLocationManagerDelegate {
    
    func checkLocationServicies() {
        if CLLocationManager.locationServicesEnabled() {
            setupLocationManager()
            checkAuthorization()
        } else {
            let alert = UIAlertController(message: NSLocalizedString("Location servicies are not enabled", comment: "Error message"))
            present(alert, animated: true)
        }
    }
    
    private func setupLocationManager() {
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.delegate = self
    }
    
    private func checkAuthorization() {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse:
            mapView.showsUserLocation = true
            centerViewOnUserLocation()
            trackUserLocation(true)
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        default:
            trackUserLocation(true)
        }
    }
    
    private func trackUserLocation(_ isEnabled: Bool) {
        if isEnabled {
            mapView.showsUserLocation = true
            mapView.userTrackingMode = .followWithHeading
            modeButton.isEnabled = true
        } else {
            mapView.showsUserLocation = false
            mapView.userTrackingMode = .none
            modeButton.isEnabled = false
        }
    }
    
    private func centerViewOnUserLocation() {
        if let location = locationManager.location?.coordinate {
            let region = MKCoordinateRegionMakeWithDistance(location, 1000, 1000)
            mapView.setRegion(region, animated: true)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkAuthorization()
    }
    
}
