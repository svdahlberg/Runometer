//
//  PaceFormatter.swift
//  Runometer
//
//  Created by Svante Dahlberg on 2017-10-07.
//  Copyright © 2017 Svante Dahlberg. All rights reserved.
//

import Foundation

struct PaceFormatter {
    static func pace(fromDistance distance: Meters, time: Seconds, outputUnit: SpeedUnit = AppConfiguration().speedUnit) -> String? {
        let pace = PaceCalculator.pace(fromDistance: distance, time: time, outputUnit: outputUnit)
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.minute, .second]
        formatter.unitsStyle = .positional
        formatter.zeroFormattingBehavior = .pad
        return formatter.string(from: TimeInterval(pace))
    }
}

