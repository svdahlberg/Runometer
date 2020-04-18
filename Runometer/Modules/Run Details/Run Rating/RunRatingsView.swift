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
        didSet {
            setupRunRatings()
            setupPageControl()
        }
    }
    
    private var runRatings: [RunRating] = [] {
        didSet { runRatingsCollectionView.reloadData() }
    }
    
    private func setupRunRatings() {
        guard let run = run else { return }
        
        runRatingsCollectionView.alpha = 0
        
        RunRatingsProvider(run: run).runRatings { [weak self] runRatings in
            guard let self = self else { return }
            self.runRatings = runRatings
            UIView.animate(withDuration: 0.5) {
                self.runRatingsCollectionView.alpha = 1
            }
        }
    }

    private func setupPageControl() {
        if #available(iOS 12.0, *) {
            let isLightMode = traitCollection.userInterfaceStyle == .light
            pageControl.pageIndicatorTintColor = isLightMode ? .gray : nil
            pageControl.currentPageIndicatorTintColor = isLightMode ? .black : nil
        }
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        setupPageControl()
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
        return CGSize(width: collectionView.frame.width -
                        collectionView.contentInset.left -
                        collectionView.contentInset.right,
                    height: collectionView.frame.height -
                        collectionView.contentInset.top -
                        collectionView.contentInset.bottom)
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        pageControl.currentPage = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
    }
    
}

