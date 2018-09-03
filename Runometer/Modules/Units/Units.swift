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

struct Pace: Numeric, Comparable, Equatable {
    static func -=(lhs: inout Pace, rhs: Pace) {
        return lhs.magnitude -= rhs.magnitude
    }
    
    static func -(lhs: Pace, rhs: Pace) -> Pace {
        return Pace(integerLiteral: lhs.magnitude - rhs.magnitude)
    }
    
    static func +=(lhs: inout Pace, rhs: Pace) {
        return lhs.magnitude += rhs.magnitude
    }
    
    static func +(lhs: Pace, rhs: Pace) -> Pace {
        return Pace(integerLiteral: rhs.magnitude + lhs.magnitude)
    }
    
    init?<T>(exactly source: T) where T : BinaryInteger {
        magnitude = Seconds(source)
    }
    
    var magnitude: Seconds
    
    static func *(lhs: Pace, rhs: Pace) -> Pace {
        return Pace(integerLiteral: lhs.magnitude * rhs.magnitude)
    }
    
    static func *=(lhs: inout Pace, rhs: Pace) {
        return lhs.magnitude *= rhs.magnitude
    }
    
    init(integerLiteral value: Seconds) {
        magnitude = value
    }
    
    typealias Magnitude = Seconds
    
    static func <(lhs: Pace, rhs: Pace) -> Bool {
        return lhs.magnitude < rhs.magnitude
    }
    
    static func ==(lhs: Pace, rhs: Pace) -> Bool {
        return lhs.magnitude == rhs.magnitude
    }
    
    typealias IntegerLiteralType = Seconds
    
}


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
        case .kilometers: return "kilometer"
        case .miles: return "mile"
        }
    }
    
    var nameInPlural: String {
        switch self {
        case .kilometers: return "kilometers"
        case .miles: return "miles"
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
