//
//  RunsExtensions.swift
//  Runometer
//
//  Created by Svante Dahlberg on 2018-09-06.
//  Copyright © 2018 Svante Dahlberg. All rights reserved.
//

import Foundation

extension Collection where Iterator.Element == RunProtocol {
    
    func within(_ range: ClosedRange<Meters>) -> [RunProtocol] {
        return filter { range.contains($0.distance) }
    }
    
    var averageDistance: Meters? {
        guard !isEmpty else {
            return nil
        }
        
        return map { $0.distance }
            .reduce(0, +) / Double(count)
    }
    
    var averagePace: Seconds? {
        guard !isEmpty else {
            return nil
        }
        let paces = map { $0.averagePace() }
        let sumOfPaces = paces.reduce(0, +)
        return sumOfPaces / count
    }
    
    var averageTime: Seconds? {
        guard !isEmpty else {
            return nil
        }
        let times = map { $0.duration }
        let sumOfTimes = times.reduce(0, +)
        return Int(sumOfTimes) / count
    }
    
}
