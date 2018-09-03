//
//  PaceCalculator.swift
//  Runometer
//
//  Created by Svante Dahlberg on 2017-10-08.
//  Copyright © 2017 Svante Dahlberg. All rights reserved.
//

import Foundation

struct PaceCalculator {
    static func pace(fromDistance distance: Meters, time: Seconds, outputUnit: SpeedUnit) -> Seconds {
        let speed = metersPerSecond(fromDistance: distance, time: time)
        let pace = reciprocal(speed * coefficient(fromDistanceUnit: outputUnit.distanceUnit))
        return Seconds(pace * 60)
    }
    
    private static func metersPerSecond(fromDistance distance: Meters, time: Seconds) -> Meters {
        return time != 0 ? distance / Double(time) : 0
    }
    
    private static func coefficient(fromDistanceUnit distanceUnit: DistanceUnit) -> Double {
        return 60.0 / distanceUnit.meters
    }
    
    private static func reciprocal(_ value: Double) -> Double {
        guard value != 0 else { return 0 }
        return 1.0 / value
    }
}

