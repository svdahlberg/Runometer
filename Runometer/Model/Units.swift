//
//  Units.swift
//  Runometer
//
//  Created by Svante Dahlberg on 2017-10-08.
//  Copyright © 2017 Svante Dahlberg. All rights reserved.
//

import Foundation

typealias Meters = Double
typealias Seconds = Int

extension Meters {
    func convert(to distanceUnit: DistanceUnit) -> Double {
        return self / distanceUnit.meters
    }
}

enum DistanceUnit {
    case kilometers
    case miles
    
    var meters: Meters {
        switch self {
        case .kilometers: return 1000
        case .miles: return 1609.344
        }
    }
    
    var symbol: String {
        switch self {
        case .kilometers: return "km"
        case .miles: return "mi"
        }
    }
    
    var name: String {
        switch self {
        case .kilometers: return "Kilometer"
        case .miles: return "Mile"
        }
    }
    
    static func parse(distanceUnitSymbol: String) -> DistanceUnit? {
        switch distanceUnitSymbol {
        case "km": return .kilometers
        case "mi": return .miles
        default: return nil
        }
    }
}

enum SpeedUnit {
    case minutesPerKilometer
    case minutesPerMile
    
    var distanceUnit: DistanceUnit {
        switch self {
        case .minutesPerKilometer: return .kilometers
        case .minutesPerMile: return .miles
        }
    }
    
    var symbol: String {
        return "min/\(distanceUnit.symbol)"
    }
}
