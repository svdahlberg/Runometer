//
//  RunRatingView.swift
//  Runometer
//
//  Created by Svante Dahlberg on 2017-11-25.
//  Copyright © 2017 Svante Dahlberg. All rights reserved.
//

import UIKit

class RunRatingView: UIView {
    @IBOutlet private weak var runometerView: RunometerView!
    
    var run: Run? {
        didSet {
            guard let run = run,
                let distance = DistanceFormatter.format(distance: run.distance),
                let allRuns = RunService.savedRuns(),
                let runsWithSimilarDistances = RunService.savedRuns(withDifferenceInDistanceSmallerThanOrEqualTo: AppConfiguration().distanceUnit.meters, toDistanceOf: run) else {
                return
            }
            let allDistances = allRuns.map { $0.distance }
            let distanceRating = RunRating.distanceRating(for: run.distance, comparedTo: allDistances)
            runometerView.percentage = distanceRating
            runometerView.value = distance
            runometerView.unitName = AppConfiguration().distanceUnit.symbol
        }
    }
    
}

