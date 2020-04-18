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
    
    private let imageWidth = 24
    private let imageHeight = 35
    private let borderWidth = 1
    private var labelWidth: Int { return imageWidth - (borderWidth * 2) }
    private var labelHeight: Int { return imageHeight - (borderWidth * 2) }
    
    private lazy var label: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.boldSystemFont(ofSize: 100)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    override var annotation: MKAnnotation? {
        didSet {
            guard let annotation = annotation as? CheckpointAnnotation else {
                return
            }
            
            if let formattedDistance = DistanceFormatter.format(distance: annotation.checkpoint.distance) {
                label.text = "\(formattedDistance) \(Settings().distanceUnit.symbol)"
            }
        }
    }
    
    init(annotation: CheckpointAnnotation, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        
        isOpaque = false
        image = UIImage(named: "checkpointAnnotation")
        frame = CGRect(x: 0, y: 0, width: imageWidth, height: imageHeight)
        centerOffset = CGPoint(x: 0, y: -imageHeight / 2)
        canShowCallout = true
        
        addSubview(label)
        label.pinToSuperview(bottom: -6)
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
