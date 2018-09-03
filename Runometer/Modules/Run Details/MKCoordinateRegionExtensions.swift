//
//  MKCoordinateRegionExtensions.swift
//  Runometer
//
//  Created by Svante Dahlberg on 2017-11-05.
//  Copyright © 2017 Svante Dahlberg. All rights reserved.
//

import MapKit

extension MKCoordinateRegion {
    
    static func region(from coordinates: [CLLocationCoordinate2D]) -> MKCoordinateRegion? {
        guard coordinates.count > 0 else { return nil }
        
        let latitudes = coordinates.map { $0.latitude }
        let longitudes = coordinates.map { $0.longitude }
        
        guard let maxLat = latitudes.max(),
            let minLat = latitudes.min(),
            let maxLong = longitudes.max(),
            let minLong = longitudes.min() else { return nil }
        
        let center = CLLocationCoordinate2D(latitude: (minLat + maxLat) / 2,
                                            longitude: (minLong + maxLong) / 2)
        let span = MKCoordinateSpan(latitudeDelta: (maxLat - minLat) * 2.1,
                                    longitudeDelta: (maxLong - minLong) * 2.1)
        return MKCoordinateRegion(center: center, span: span)
    }
    
}
