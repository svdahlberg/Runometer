//
//  StatisticsViewController.swift
//  Runometer
//
//  Created by Svante Dahlberg on 2018-09-10.
//  Copyright © 2018 Svante Dahlberg. All rights reserved.
//

import UIKit

class StatisticsViewController: UIViewController {
    
    @IBOutlet private weak var collectionView: UICollectionView!
    
    private var runStatistics: [RunStatistic]? {
        didSet { collectionView.reloadData() }
    }
    
    private var statistics: Statistics? {
        didSet {
            runStatistics = [
                statistics?.totalDistance(),
                statistics?.numberOfRuns(),
                statistics?.totalDuration(),
                statistics?.longestDistance(),
                statistics?.fastestPace(),
                statistics?.averageDistance(),
                statistics?.averagePace()
                ].compactMap { $0 }
        }
    }
    
    let transition = ScaleAnimator()
    
    private var selectedCell: UICollectionViewCell?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadStatistics()
    }
    
    private func loadStatistics() {
        StatisticsProvider().statistics { [weak self] statistics in
            self?.statistics = statistics
        }
    }
    
}

extension StatisticsViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return runStatistics?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RunStatisticCollectionViewCell", for: indexPath) as? RunStatisticCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.runStatistic = runStatistics?[indexPath.row]
        return cell
    }
    
}

extension StatisticsViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedCell = collectionView.cellForItem(at: indexPath)
        
        guard let statisticDetailViewController = storyboard?.instantiateViewController(withIdentifier: "RunStatisticDetailViewController") as? RunStatisticDetailViewController else {
            return
        }
        
        statisticDetailViewController.runStatistic = runStatistics?[indexPath.row]
        statisticDetailViewController.transitioningDelegate = self
        present(statisticDetailViewController, animated: true)
    }
    
}

extension StatisticsViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width/2 - 16
        return CGSize(width: width, height: width * 0.75)
    }
    
}

extension StatisticsViewController: UIViewControllerTransitioningDelegate {
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        transition.originFrame = selectedCell!.superview!.convert(selectedCell!.frame, to: nil)
        
        transition.presenting = true
//        selectedCell!.isHidden = true
        
        return nil
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.presenting = false
        return nil
    }
    
}
