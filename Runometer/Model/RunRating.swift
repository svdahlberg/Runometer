//
//  RunRating.swift
//  Runometer
//
//  Created by Svante Dahlberg on 2017-11-25.
//  Copyright © 2017 Svante Dahlberg. All rights reserved.
//

import Foundation
import CoreGraphics

struct RunRating {
    
    static func distanceRating(for distance: Meters, comparedTo distances: [Meters], minimumRating: CGFloat = 0.01, maximumRating: CGFloat = 1) -> CGFloat {
        return rating(for: distance, comparedTo: distances, minimumRating: minimumRating, maximumRating: maximumRating) ?? 0
    }
    
    static func timeRating(for duration: Seconds, comparedTo durations: [Seconds], minimumRating: CGFloat = 0.01, maximumRating: CGFloat = 1) -> CGFloat {
        let value = Double(duration)
        let values = durations.map { Double($0) }
        guard let timeRating = rating(for: value, comparedTo: values, minimumRating: minimumRating, maximumRating: maximumRating) else { return 0 }
        guard values.count > 1 else { return maximumRating }
        return max(1 - timeRating, minimumRating)
    }
    
    private static func rating(for value: Double, comparedTo values: [Double], minimumRating: CGFloat, maximumRating: CGFloat) -> CGFloat? {
        guard !values.isEmpty else { return nil }
        let sortedValues = values.sorted { $0 < $1 }
        
        if let highestValue = sortedValues.last, value == highestValue {
            return maximumRating
        }
        
        if let lowestValue = sortedValues.first, value == lowestValue {
            return minimumRating
        }
        
        let averageValue = values.reduce(0, +) / Double(values.count)
        if value == averageValue {
            return average(of: maximumRating, and: minimumRating)
        }
        
        if value < averageValue, let lowValues = sortedValues.split(whereSeparator: { $0 >= averageValue }).first {
            return rating(for: value, comparedTo: Array(lowValues), minimumRating: minimumRating, maximumRating: average(of: maximumRating, and: minimumRating))
        }
        
        if value > averageValue, let highValues = sortedValues.split(whereSeparator: { $0 <= averageValue }).first {
            return rating(for: value, comparedTo: Array(highValues), minimumRating: average(of: maximumRating, and: minimumRating), maximumRating: maximumRating)
        }
        
        return nil
    }

}

extension RunRating {
    private static func average(of number1: CGFloat, and number2: CGFloat) -> CGFloat {
        return (number1 + number2) / 2
    }
}
