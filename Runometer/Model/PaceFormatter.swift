//
//  PaceFormatter.swift
//  Runometer
//
//  Created by Svante Dahlberg on 2017-10-07.
//  Copyright © 2017 Svante Dahlberg. All rights reserved.
//

import Foundation

struct PaceFormatter {
    
    static func pace(fromDistance distance: Meters, time: Seconds, outputUnit: SpeedUnit = Settings().speedUnit) -> String? {
        let pace = PaceCalculator.pace(fromDistance: distance, time: time, outputUnit: outputUnit)
        return format(pace: pace)
    }
    
    static func format(pace: Seconds, outputUnit: SpeedUnit = Settings().speedUnit) -> String? {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.minute, .second]
        formatter.unitsStyle = .positional
        formatter.zeroFormattingBehavior = .pad
        return formatter.string(from: TimeInterval(pace))
    }
    
    static func formatUsingLongUnitName(pace: Seconds, outputUnit: SpeedUnit = Settings().speedUnit) -> String? {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.minute, .second]
        formatter.unitsStyle = .full
        formatter.zeroFormattingBehavior = .dropAll
        guard let timeString = formatter.string(from: TimeInterval(pace)) else { return nil }
        return "\(timeString) per \(outputUnit.distanceUnit.name)"
    }
    
}

