//
//  MapViewControllerMKMapViewDelegateExtension.swift
//  PhotoApp
//
//  Created by mac-089-71 on 9/7/18.
//  Copyright © 2018 VPavelDm. All rights reserved.
//

import Foundation
import MapKit

extension MapViewController: MKMapViewDelegate {
    
    func addAnnotation(photo: Photo) {
        mapView.addAnnotation(photo)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let annotation = annotation as? Photo else {
            return nil
        }
        let annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: annotation.category)
        //MARK: Add choosing between different markers
        annotationView.image = UIImage(named: "marker_nature")
        let photoDetail = PhotoDetailView()
        let dateFormatter = DateFormatter()
        photoDetail.dateLabel.text = dateFormatter.convertString(string: annotation.date, by: "MM-dd-yyyy")
        photoDetail.descriptionLabel.text = annotation.photoDescription
        photoDetail.photoImage.image = annotation.image
        annotationView.detailCalloutAccessoryView = photoDetail
        annotationView.canShowCallout = true
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, didChange mode: MKUserTrackingMode, animated: Bool) {
        if mode == .none {
            modeButton.setImage(UIImage(named: "ic_center_on_me_disable"), for: .normal)
        } else {
            modeButton.setImage(UIImage(named: "ic_center_on_me_selected"), for: .normal)
        }
    }
}
