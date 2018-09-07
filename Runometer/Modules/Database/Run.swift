//
//  Run.swift
//  Runometer
//
//  Created by Svante Dahlberg on 2018-09-06.
//  Copyright © 2018 Svante Dahlberg. All rights reserved.
//

import CoreLocation

protocol Run {
    var distance: Meters { get }
    var duration: Seconds { get }
    var startDate: Date { get }
    var endDate: Date { get }
    func locationSegments(completion: @escaping ([[CLLocation]]) -> Void)
}

extension Run {
    
    func averagePace(speedUnit: SpeedUnit = Settings().speedUnit) -> Seconds {
        return PaceCalculator.pace(fromDistance: distance, time: Seconds(duration), outputUnit: speedUnit)
    }
    
    func similarRunsRange(distanceUnit: DistanceUnit = Settings().distanceUnit) -> ClosedRange<Meters> {
        let roundedDistance = Meters(distance.number(of: distanceUnit)) * distanceUnit.meters
        let lowerBound = max(roundedDistance - distanceUnit.meters, 0)
        var upperBound = roundedDistance + distanceUnit.meters
        if lowerBound == 0 {
            upperBound += distanceUnit.meters - roundedDistance
        }
        
        return  lowerBound...upperBound
    }
    
}
