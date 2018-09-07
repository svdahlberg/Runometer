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
            run?.locationSegments { [weak self] locationSegments in
                guard let runMap = RunMap(locationSegments: locationSegments) else { return }
                runMap.polylines.forEach { self?.mapView.add($0) }
                self?.mapView.region = runMap.mapRegion
                self?.mapView.addAnnotations(runMap.checkpointAnnotations)
                self?.mapView.addAnnotation(runMap.startAnnotation)
                self?.mapView.addAnnotation(runMap.endAnnotation)
            }
            
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
    
    init?(locationSegments: [[CLLocation]]) {
        let coordinateSegments = locationSegments.coordinateSegments()
        let coordinates = locationSegments.flattenedCoordinateSegments()
        guard let mapRegion = MKCoordinateRegion.region(from: coordinates),
            let reachedCheckpoints = locationSegments.reachedCheckpoints(),
            let startAnnotation = locationSegments.startAnnotation(),
            let endAnnotation = locationSegments.endAnnotation()
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
