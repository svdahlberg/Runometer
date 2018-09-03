//
//  RunSummaryMapView.swift
//  Runometer
//
//  Created by Svante Dahlberg on 2017-10-29.
//  Copyright © 2017 Svante Dahlberg. All rights reserved.
//

import UIKit
import MapKit

protocol RunSummaryMapViewDelegate: class {
    func runSummaryMapViewDidGetPressed(_ runSummaryMapView: RunSummaryMapView)
}

class RunSummaryMapView: UIView {
    @IBOutlet private weak var mapView: MKMapView!
    
    weak var delegate: RunSummaryMapViewDelegate?
    
    var run: Run? {
        didSet {
            guard let runMap = RunMap(run: run) else {
                return
            }
            
            runMap.polylines.forEach { mapView.add($0) }
            mapView.region = runMap.mapRegion
            mapView.addAnnotations(runMap.checkpointAnnotations)
            mapView.addAnnotation(runMap.startAnnotation)
            mapView.addAnnotation(runMap.endAnnotation)
            
            setupTapGestureRecognizer()
        }
    }
    
    private func setupTapGestureRecognizer() {
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        addGestureRecognizer(gestureRecognizer)
    }
    
    @objc private func handleTap(sender: UITapGestureRecognizer) {
        delegate?.runSummaryMapViewDidGetPressed(self)
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

struct RunMap {
    
    let mapRegion: MKCoordinateRegion
    let polylines: [MKPolyline]
    let checkpointAnnotations: [CheckpointAnnotation]
    let startAnnotation: StartAnnotation
    let endAnnotation: EndAnnotation
    
    init?(run: Run?) {
        guard let coordinateSegments = run?.coordinateSegments(),
            let coordinates = run?.flattenedCoordinateSegments(),
            let mapRegion = MKCoordinateRegion.region(from: coordinates),
            let reachedCheckpoints = run?.reachedCheckpoints(),
            let startAnnotation = run?.startAnnotation(),
            let endAnnotation = run?.endAnnotation()
        else {
                return nil
        }
        
        self.polylines = MKPolyline.polylines(from: coordinateSegments)
        self.mapRegion = mapRegion
        self.checkpointAnnotations = reachedCheckpoints.map { CheckpointAnnotation(checkpoint: $0) }
        self.startAnnotation = startAnnotation
        self.endAnnotation = endAnnotation
    }
}
