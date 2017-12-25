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
            let paceRatingViewController = paceRatingViewController
        else {
            return []
        }
        
        return [distanceRatingViewController, paceRatingViewController]
    }()
    
    private lazy var distanceRatingViewController: RunRatingViewController? = {
        guard let run = run,
            let distance = DistanceFormatter.format(distance: run.distance),
            let allRuns = RunService.savedRuns() else {
                return nil
        }
        
        let allDistances = allRuns.map { $0.distance }
        let distanceRating = RunRating.distanceRating(for: run.distance, comparedTo: allDistances)
        return runRatingViewController(percentage: distanceRating, value: distance, unitName: AppConfiguration().distanceUnit.symbol)
    }()
    
    private lazy var paceRatingViewController: RunRatingViewController? = {
        guard let run = run,
            let pace = PaceFormatter.pace(fromDistance: run.distance, time: Seconds(run.duration)),
             let runsWithSimilarDistances = RunService.savedRuns(withDifferenceInDistanceSmallerThanOrEqualTo: AppConfiguration().distanceUnit.meters, toDistanceOf: run)
            else {
                return nil
        }
        
        let paces = runsWithSimilarDistances.map { $0.averagePace() }
        let paceRating = RunRating.timeRating(for: run.averagePace(), comparedTo: paces)
        return runRatingViewController(percentage: paceRating, value: pace, unitName: AppConfiguration().speedUnit.symbol)
    }()
    
    private func runRatingViewController(percentage: CGFloat, value: String, unitName: String) -> RunRatingViewController? {
        guard let runRatingViewController = storyboard?.instantiateViewController(withIdentifier: "RunRatingViewControllerStoryboardIdentifier") as? RunRatingViewController else {
            return nil
        }
        
        runRatingViewController.runometerViewPercentage = percentage
        runRatingViewController.runometerViewValue = value
        runRatingViewController.runometerViewUnitName = unitName
        return runRatingViewController
    }
    
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
    
}

extension RunRatingPageViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let runRatingViewController = viewController as? RunRatingViewController,
            let viewControllerIndex = runRatingViewControllers.index(of: runRatingViewController) else {
            return nil
        }
        
        let previousIndex = viewControllerIndex - 1
        
        guard previousIndex >= 0 else {
            return nil
        }
        
        guard runRatingViewControllers.count > previousIndex else {
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
        
        guard runRatingViewControllers.count != nextIndex else {
            return nil
        }
        
        guard runRatingViewControllers.count > nextIndex else {
            return nil
        }
        
        return runRatingViewControllers[nextIndex]
    }
    
    
}
