//
//  RunSummaryMapView.swift
//  Runometer
//
//  Created by Svante Dahlberg on 2017-10-29.
//  Copyright © 2017 Svante Dahlberg. All rights reserved.
//

import UIKit
import MapKit

class RunSummaryMapView: UIView {
    @IBOutlet private weak var mapView: MKMapView!
    
    var run: Run? {
        didSet {
            guard let coordinateSegments = run?.coordinateSegments(),
                let coordinates = run?.flattenedCoordinateSegments(),
                let mapRegion = MKCoordinateRegion.region(from: coordinates),
                let reachedCheckpoints = run?.reachedCheckpoints()
            else { return }
            let polylines = MKPolyline.polylines(from: coordinateSegments)
            polylines.forEach { mapView.add($0) }
            mapView.region = mapRegion
            let checkpointAnnotations = reachedCheckpoints.map { CheckpointAnnotation(checkpoint: $0) }
            mapView.addAnnotations(checkpointAnnotations)
            if let startAnnotation = run?.startAnnotation() {
                mapView.addAnnotation(startAnnotation)
            }
            if let endAnnotation = run?.endAnnotation() {
                mapView.addAnnotation(endAnnotation)
            }
        }
    }
    
    
    
}

extension RunSummaryMapView: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        return self.mapView.overlayRenderer(for: overlay)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        return self.mapView.annotationView(for: annotation, on: mapView)
    }
}


