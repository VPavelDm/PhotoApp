//
//  CoordinationManager.swift
//  PhotoApp
//
//  Created by mac-089-71 on 9/7/18.
//  Copyright © 2018 VPavelDm. All rights reserved.
//

import Foundation
import MapKit

class CoordinationManager {
    
    private init() {}
    private var lastCoordinate: CLLocationCoordinate2D?
    
    static let manager = CoordinationManager()
    
    func sendCoordinate(_ coordinate: CLLocationCoordinate2D) {
        lastCoordinate = coordinate
    }
    
    func getLastCoordinate() -> CLLocationCoordinate2D {
        return lastCoordinate ?? CLLocationCoordinate2D(latitude: 0, longitude: 0)
    }
}
