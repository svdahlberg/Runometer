//
//  HealthKitRun.swift
//  Runometer
//
//  Created by Svante Dahlberg on 2018-09-06.
//  Copyright © 2018 Svante Dahlberg. All rights reserved.
//

import CoreLocation

struct HealthKitRun: RunProtocol {
    var distance: Meters
    
    var duration: Seconds
    
    var startDate: Date
    
    var endDate: Date
    
    func locationSegments() -> [[CLLocation]]? {
        return nil
    }
    
}
