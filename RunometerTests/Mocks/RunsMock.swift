//
//  RunsMock.swift
//  RunometerTests
//
//  Created by Svante Dahlberg on 2017-12-26.
//  Copyright © 2017 Svante Dahlberg. All rights reserved.
//

import Foundation
@testable import Runometer
import CoreData

extension ManagedRunObject {
    class func runsMock(context: NSManagedObjectContext) -> [ManagedRunObject] {
        return [
            ManagedRunObject(context: context, distance: 5000, time: 1500, locationSegments: [], date: Date(timeIntervalSince1970: 2)), // average pace: 300 seconds
            ManagedRunObject(context: context, distance: 1000, time: 200, locationSegments: [], date: Date(timeIntervalSince1970: 1)), // average pace: 200 seconds
            ManagedRunObject(context: context, distance: 4000, time: 1600, locationSegments: [], date: Date(timeIntervalSince1970: 2)), // average pace: 400 seconds
            ManagedRunObject(context: context, distance: 6000, time: 1800, locationSegments: [], date: Date(timeIntervalSince1970: 3)), // average pace: 300 seconds
            ManagedRunObject(context: context, distance: 10000, time: 3000, locationSegments: [], date: Date(timeIntervalSince1970: 2)) // average pace: 300 seconds
        ]
    }
    
    class func runMock(context: NSManagedObjectContext) -> ManagedRunObject {
        return ManagedRunObject(context: context, distance: 5000, time: 1500, locationSegments: [], date: Date(timeIntervalSince1970: 2)) // average pace: 300
    }
    
}
