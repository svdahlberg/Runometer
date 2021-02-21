//
//  RunStatistic.swift
//  Runometer
//
//  Created by Svante Dahlberg on 2018-09-13.
//  Copyright © 2018 Svante Dahlberg. All rights reserved.
//

import Foundation

enum UnitType {
    case distance, speed, time, count
}

struct UnitTypeConverter {
    
    private let settings: Settings
    
    init(settings: Settings = Settings()) {
        self.settings = settings
    }
    
    func unit(for unitType: UnitType) -> RunUnit? {
        switch unitType {
        case .distance: return settings.distanceUnit
        case .speed: return settings.speedUnit
        default: return nil
        }
    }
}

struct RunStatistic {
    
    let value: Double
    let title: String
    let date: Date
    let unitType: UnitType
    let type: RunStatisticType
    
    private let unitTypeConverter: UnitTypeConverter
    
    init(value: Double, title: String, date: Date, unitType: UnitType, type: RunStatisticType, unitTypeConverter: UnitTypeConverter = UnitTypeConverter()) {
        self.value = value
        self.title = title
        self.date = date
        self.unitType = unitType
        self.type = type
        self.unitTypeConverter = unitTypeConverter
    }
    
    var formattedValue: String? {
        switch unitType {
        case .distance:
            return DistanceFormatter.format(distance: value)
        case .speed:
            return PaceFormatter.format(pace: Seconds(value))
        case .time:
            return TimeFormatter.format(time: Seconds(value))
        case .count:
            return String(Int(value))
        }
    }
    
    var unitSymbol: String {
        guard let unit = unitTypeConverter.unit(for: unitType) else {
            return ""
        }
        
        return unit.symbol
    }
    
}
