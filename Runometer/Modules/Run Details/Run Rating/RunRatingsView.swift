//
//  RunRatingsView.swift
//  Runometer
//
//  Created by Svante Dahlberg on 2018-09-03.
//  Copyright © 2018 Svante Dahlberg. All rights reserved.
//

import UIKit

class RunRatingsView: UIView {
    
    @IBOutlet private weak var runRatingsCollectionView: UICollectionView!
    @IBOutlet private weak var pageControl: UIPageControl!
    
    var run: Run? {
        didSet { setupRunRatings() }
    }
    
    private var runRatings: [RunRating] = [] {
        didSet { runRatingsCollectionView.reloadData() }
    }
    
    private func setupRunRatings() {
        guard let run = run else { return }
        RunProvider().runs { allRuns in
            let similarDistanceRuns = allRuns.within(run.similarRunsRange())
            let runRatingProvider = RunRatingProvider(run: run)
            runRatings = [runRatingProvider.distanceRating(comparedTo: allRuns),
                          runRatingProvider.timeRating(comparedTo: similarDistanceRuns),
                          runRatingProvider.paceRating(comparedTo: allRuns)].compactMap { $0 }
        }
    }
    
}

extension RunRatingsView: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let numberOfItems = runRatings.count
        pageControl.numberOfPages = numberOfItems
        pageControl.isHidden = !(numberOfItems > 1)
        return numberOfItems
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RunRatingCollectionViewCellReuseIdentifier", for: indexPath) as! RunRatingCollectionViewCell
        cell.runRating = runRatings[indexPath.row]
        return cell
    }
    
}

extension RunRatingsView: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.frame.size
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        pageControl.currentPage = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
    }
    
}

