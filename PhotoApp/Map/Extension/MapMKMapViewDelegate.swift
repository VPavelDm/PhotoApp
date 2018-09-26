//
//  MapViewControllerMKMapViewDelegateExtension.swift
//  PhotoApp
//
//  Created by mac-089-71 on 9/7/18.
//  Copyright © 2018 VPavelDm. All rights reserved.
//

import Foundation
import MapKit

extension MapViewController: MKMapViewDelegate, PhotoDetailDelegate {
    
    func addAnnotation(photo: Photo) {
        if categories.contains(Category(rawValue: photo.category)!){
            mapView.addAnnotation(photo)
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let annotation = annotation as? Photo else {
            return nil
        }
        let annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: annotation.category)
        annotationView.image = getMarkerPin(by: Category(rawValue: annotation.category)!)
        let photoDetail = PhotoDetailView()
        photoDetail.photo = annotation
        photoDetail.delegate = self
        annotationView.detailCalloutAccessoryView = photoDetail
        annotationView.canShowCallout = true
        return annotationView
    }
    
    func clickedMarker(photo: Photo) {
        let viewController = PhotoModificationViewController.create(asClass: PhotoModificationViewController.self)
        viewController.delegate = self
        viewController.photo = photo
        for annotation in mapView.selectedAnnotations {
            mapView.deselectAnnotation(annotation, animated: true)
        }
        present(viewController, animated: true)
    }
    
    func mapView(_ mapView: MKMapView, didChange mode: MKUserTrackingMode, animated: Bool) {
        if mode == .none {
            modeButton.setImage(UIImage(named: "ic_center_on_me_disable"), for: .normal)
        } else {
            modeButton.setImage(UIImage(named: "ic_center_on_me_selected"), for: .normal)
        }
    }
    
    private func getMarkerPin(by category: Category) -> UIImage {
        let imageName: String
        switch category {
        case .nature:
            imageName = "marker_nature"
        case .friends:
            imageName = "marker_friends"
        case .default_category:
            imageName = "marker_default"
        }
        return UIImage(named: imageName)!
    }
}
