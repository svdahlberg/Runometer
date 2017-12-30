//
//  RunRatingDescription.swift
//  Runometer
//
//  Created by Svante Dahlberg on 2017-12-26.
//  Copyright © 2017 Svante Dahlberg. All rights reserved.
//

import Foundation
import CoreGraphics

struct RunRatingDescription {

    let best: CGFloat
    lazy var good = best * 0.75
    lazy var average = best/2
    lazy var bad = best/4
    let worst: CGFloat
    lazy var veryGoodRange = good..<best
    lazy var goodRange = average..<good
    lazy var badRange = bad..<average
    lazy var veryBadRange = worst..<bad

    init(ratingRange: ClosedRange<CGFloat> = AppConfiguration().runRatingRange) {
        best = ratingRange.upperBound
        worst = ratingRange.lowerBound
    }
    
    
}
