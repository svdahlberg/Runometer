//
//  DistanceFormatter.swift
//  Runometer
//
//  Created by Svante Dahlberg on 2017-10-07.
//  Copyright © 2017 Svante Dahlberg. All rights reserved.
//

import Foundation

struct DistanceFormatter {
    static func format(distance: Meters, outputUnit: DistanceUnit = AppConfiguration().distanceUnit) -> String? {
        let convertedDistance = distance.convert(to: outputUnit)
        let numberFormatter = NumberFormatter()
        numberFormatter.maximumFractionDigits = 2
        return numberFormatter.string(from: NSNumber(value: convertedDistance))
    }
    
    static func formatWithLongUnitName(distance: Meters, outputUnit: DistanceUnit = AppConfiguration().distanceUnit) -> String? {
        guard let value = format(distance: distance, outputUnit: outputUnit) else {
            return nil
        }
        
        let outputUnitName = distance == outputUnit.meters ? outputUnit.name : outputUnit.nameInPlural
        return "\(value) \(outputUnitName)"
    }
}

