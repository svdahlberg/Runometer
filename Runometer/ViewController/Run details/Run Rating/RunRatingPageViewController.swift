//
//  RunRatingPageViewController.swift
//  Runometer
//
//  Created by Svante Dahlberg on 2017-12-25.
//  Copyright © 2017 Svante Dahlberg. All rights reserved.
//

import UIKit

class RunRatingPageViewController: UIPageViewController {
    
    var run: Run?
    
    private lazy var runRatingViewControllers: [RunRatingViewController] = {
        guard let distanceRatingViewController = distanceRatingViewController,
            let paceRatingViewController = paceRatingViewController,
            let timeRatingViewController = timeRatingViewController
        else {
            return []
        }
        
        return [distanceRatingViewController, timeRatingViewController, paceRatingViewController]
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = self
        
        if let firstViewController = runRatingViewControllers.first {
            setViewControllers([firstViewController],
                               direction: .forward,
                               animated: true,
                               completion: nil)
        }
    }
    
    private lazy var distanceRatingViewController: RunRatingViewController? = {
        guard let run = run,
            let formattedDistance = DistanceFormatter.format(distance: run.distance),
            let statisticsText = RunStatistics().allDistancesStatisticsText(for: run.distance),
            let runs = RunService().savedRuns() else {
                return nil
        }
        
        let allDistances = runs.map { $0.distance }
        let distanceRating = RunRating.distanceRating(for: run.distance, comparedTo: allDistances)
        return runRatingViewController(percentage: distanceRating, value: formattedDistance, unitName: AppConfiguration().distanceUnit.symbol, ratingInformation: statisticsText)
    }()
    
    private lazy var timeRatingViewController: RunRatingViewController? = {
        guard
            let run = run,
            let formattedTime = TimeFormatter.format(time: Seconds(run.duration)),
            let runsWithSimilarDistances = RunService().savedRuns(withinDistanceRange: (run.distance - AppConfiguration().distanceUnit.meters)...(run.distance + AppConfiguration().distanceUnit.meters)),
            let timeRatingStatisticsText = RunStatistics().averageTimeStatisticsText(for: Seconds(run.duration), withinDistanceRange: (run.distance - AppConfiguration().distanceUnit.meters)...(run.distance + AppConfiguration().distanceUnit.meters))
            else {
                return nil
        }
        
        let times = runsWithSimilarDistances.map { Seconds($0.duration) }
        let timeRating = RunRating.timeRating(for: Seconds(run.duration), comparedTo: times)

        return runRatingViewController(percentage: timeRating, value: formattedTime, unitName: "Time", ratingInformation: timeRatingStatisticsText)
    }()
    
    private lazy var paceRatingViewController: RunRatingViewController? = {
        guard
            let run = run,
            let formattedPace = PaceFormatter.pace(fromDistance: run.distance, time: Seconds(run.duration)),
            let runsWithSimilarDistances = RunService().savedRuns(withinDistanceRange: (run.distance - AppConfiguration().distanceUnit.meters)...(run.distance + AppConfiguration().distanceUnit.meters)),
            let paceRatingStatisticsText = RunStatistics().averagePaceStatisticsText(for: run.averagePace())
            else {
                return nil
        }
        
        let paces = runsWithSimilarDistances.map { $0.averagePace() }
        let paceRating = RunRating.timeRating(for: run.averagePace(), comparedTo: paces)

        return runRatingViewController(percentage: paceRating, value: formattedPace, unitName: AppConfiguration().speedUnit.symbol, ratingInformation: paceRatingStatisticsText)
    }()
    
    private func runRatingViewController(percentage: CGFloat, value: String, unitName: String, ratingInformation: String) -> RunRatingViewController? {
        guard let runRatingViewController = storyboard?.instantiateViewController(withIdentifier: "RunRatingViewControllerStoryboardIdentifier") as? RunRatingViewController else {
            return nil
        }
        
        runRatingViewController.runometerViewPercentage = percentage
        runRatingViewController.runometerViewValue = value
        runRatingViewController.runometerViewUnitName = unitName
        runRatingViewController.ratingDescription = ratingInformation
        return runRatingViewController
    }
    
}

extension RunRatingPageViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let runRatingViewController = viewController as? RunRatingViewController,
            let viewControllerIndex = runRatingViewControllers.index(of: runRatingViewController) else {
            return nil
        }
        
        let previousIndex = viewControllerIndex - 1
        
        guard previousIndex >= 0, runRatingViewControllers.count > previousIndex else {
            return nil
        }
        
        return runRatingViewControllers[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let runRatingViewController = viewController as? RunRatingViewController,
            let viewControllerIndex = runRatingViewControllers.index(of: runRatingViewController) else {
                return nil
        }
        
        let nextIndex = viewControllerIndex + 1
        
        guard runRatingViewControllers.count != nextIndex, runRatingViewControllers.count > nextIndex else {
            return nil
        }
        
        return runRatingViewControllers[nextIndex]
    }
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return runRatingViewControllers.count
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return 0
    }
    
}
