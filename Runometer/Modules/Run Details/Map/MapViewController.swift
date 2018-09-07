//
//  MapViewController.swift
//  Runometer
//
//  Created by Svante Dahlberg on 2018-02-07.
//  Copyright © 2018 Svante Dahlberg. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
    
    @IBOutlet private weak var mapView: MKMapView!
    
    var run: Run?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupMapView()
    }
    
    private func setupMapView() {
        
        run?.locationSegments { [weak self] locationSegments in
            guard let runMap = RunMap(locationSegments: locationSegments) else { return }
            runMap.polylines.forEach { self?.mapView.add($0) }
            self?.mapView.region = runMap.mapRegion
            self?.mapView.addAnnotations(runMap.checkpointAnnotations)
            self?.mapView.addAnnotation(runMap.startAnnotation)
            self?.mapView.addAnnotation(runMap.endAnnotation)
        }

    }
    
}

extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        return mapView.overlayRenderer(for: overlay)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        return mapView.annotationView(for: annotation, on: mapView)
    }
}
