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
    
    var run: RunProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupMapView()
    }
    
    private func setupMapView() {
        guard let runMap = RunMap(run: run) else {
            return
        }
        
        runMap.polylines.forEach { mapView.add($0) }
        mapView.region = runMap.mapRegion
        mapView.addAnnotations(runMap.checkpointAnnotations)
        mapView.addAnnotation(runMap.startAnnotation)
        mapView.addAnnotation(runMap.endAnnotation)
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
