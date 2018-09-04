//
//  MKPolyLineExtensions.swift
//  Runometer
//
//  Created by Svante Dahlberg on 2017-11-05.
//  Copyright © 2017 Svante Dahlberg. All rights reserved.
//

import MapKit

extension MKPolyline {
    class func polylines(from coordinateSegments: [[CLLocationCoordinate2D]]) -> [MKPolyline] {
        return coordinateSegments.map {
            MKPolyline(coordinates: $0, count: $0.count)
        }
    }
}
