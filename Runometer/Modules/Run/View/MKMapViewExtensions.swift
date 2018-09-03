//
//  MKMapViewExtensions.swift
//  Runometer
//
//  Created by Svante Dahlberg on 2017-10-29.
//  Copyright © 2017 Svante Dahlberg. All rights reserved.
//

import MapKit

extension MKMapView {
    func centerOnUser(offsetMultiplier: (latitude: CLLocationDegrees?, longitude: CLLocationDegrees?) = (nil, nil)) {
        var centerCoordinate = userLocation.coordinate
        let region = MKCoordinateRegionMakeWithDistance(centerCoordinate, 500, 500)
        setRegion(region, animated: true)
        
        if let latitudeMultiplier = offsetMultiplier.latitude {
            centerCoordinate.latitude += region.span.latitudeDelta * latitudeMultiplier
        }
        if let longitudeMultiplier = offsetMultiplier.longitude {
            centerCoordinate.longitude += region.span.longitudeDelta * longitudeMultiplier
        }
        
        setCenter(centerCoordinate, animated: true)
    }
    
    func annotationView(for annotation: MKAnnotation, on mapView: MKMapView) -> MKAnnotationView? {
        if let annotation = annotation as? CheckpointAnnotation  {
            let reuseIdentifier = "checkpoint"
            let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseIdentifier) ??
                CheckpointAnnotationView(annotation: annotation, reuseIdentifier: reuseIdentifier)
            annotationView.annotation = annotation
            return annotationView
        }
        if let annotation = annotation as? StartAnnotation {
            let reuseIdentifier = "start"
            let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseIdentifier) ??
                StartAnnotationView(annotation: annotation, reuseIdentifier: reuseIdentifier)
            annotationView.annotation = annotation
            return annotationView
        }
        if let annotation = annotation as? EndAnnotation {
            let reuseIdentifier = "end"
            let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseIdentifier) ??
                EndAnnotationView(annotation: annotation, reuseIdentifier: reuseIdentifier)
            annotationView.annotation = annotation
            return annotationView
        }
        return nil
    }
    
    func overlayRenderer(for overlay: MKOverlay) -> MKOverlayRenderer {
        guard let polyline = overlay as? MKPolyline else {
            return MKOverlayRenderer(overlay: overlay)
        }
        let renderer = MKPolylineRenderer(polyline: polyline)
        renderer.strokeColor = .darkGray
        renderer.lineWidth = 5
        return renderer
    }

}



