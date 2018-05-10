//
//  CheckpointAnnotationView.swift
//  Runometer
//
//  Created by Svante Dahlberg on 2017-10-22.
//  Copyright © 2017 Svante Dahlberg. All rights reserved.
//

import UIKit
import MapKit

class CheckpointAnnotationView: MKAnnotationView {
    init(annotation: CheckpointAnnotation, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        
        let imageWidth = 24
        let imageHeight = 35
        let borderWidth = 1
        let labelWidth = imageWidth - (borderWidth * 2)
        let labelHeight = imageHeight - (borderWidth * 2)
        
        isOpaque = false
        image = UIImage(named: "checkpointAnnotation")
        frame = CGRect(x: 0, y: 0, width: imageWidth, height: imageHeight)
        centerOffset = CGPoint(x: 0, y: -imageHeight / 2)
        canShowCallout = true
        
        let label = UILabel(frame: CGRect(x: borderWidth, y: -3, width: labelWidth, height: labelHeight))
        if let formattedDistance = DistanceFormatter.format(distance: annotation.checkpoint.distance) {
            label.text = "\(formattedDistance) \(Settings().distanceUnit.symbol)"
        }
        label.font = UIFont.boldSystemFont(ofSize: 100)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.adjustsFontSizeToFitWidth = true
        addSubview(label)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}


class StartAnnotationView: MKAnnotationView {
    init(annotation: StartAnnotation, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        let imageWidth = 24
        let imageHeight = 35
        image = UIImage(named: "startAnnotation")
        frame = CGRect(x: 0, y: 0, width: imageWidth, height: imageHeight)
        centerOffset = CGPoint(x: 0, y: -imageHeight / 2)
        canShowCallout = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


class EndAnnotationView: MKAnnotationView {
    init(annotation: EndAnnotation, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        let imageWidth = 24
        let imageHeight = 35
        image = UIImage(named: "endAnnotation")
        frame = CGRect(x: 0, y: 0, width: imageWidth, height: imageHeight)
        centerOffset = CGPoint(x: 0, y: -imageHeight / 2)
        canShowCallout = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
