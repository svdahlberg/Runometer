//
//  RunExtensions.swift
//  Runometer
//
//  Created by Svante Dahlberg on 2017-10-29.
//  Copyright © 2017 Svante Dahlberg. All rights reserved.
//

import Foundation
import CoreData
import CoreLocation

extension ManagedRunObject {
    
    convenience init(context: NSManagedObjectContext, distance: Meters, time: Seconds, locationSegments: [[CLLocation]], date: Date = Date()) {
        self.init(context: context)
        self.distance = distance
        self.duration = Int16(time)
        self.timestamp = date
        self.startDate = Calendar.current.date(byAdding: .second, value: Int(-duration), to: date)
        self.endDate = date
        
        for locationSegment in locationSegments {
            let runSegmentObject = RunSegment(context: context)
            for location in locationSegment {
                let locationObject = Location(context: context)
                locationObject.timestamp = location.timestamp
                locationObject.latitude = location.coordinate.latitude
                locationObject.longitude = location.coordinate.longitude
                runSegmentObject.addToLocations(locationObject)
            }
            self.addToRunSegments(runSegmentObject)
        }
    }
    
}
