//
//  StatisticsViewController.swift
//  Runometer
//
//  Created by Svante Dahlberg on 2018-09-10.
//  Copyright © 2018 Svante Dahlberg. All rights reserved.
//

import UIKit

class StatisticsViewController: UIViewController {
    
    private var selectedCell: RunStatisticCollectionViewCell?
    
    @IBOutlet private weak var collectionView: UICollectionView!

    private lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(loadStatistics), for: .valueChanged)
        return refreshControl
    }()

    private let viewModel = StatisticsViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.refreshControl = refreshControl
        viewModel.didLoadStatistics = { [weak self] in
            self?.refreshControl.endRefreshing()
            self?.collectionView.reloadData()
        }
    }
    
    @objc private func loadStatistics() {
        viewModel.loadStatistics()
    }

}

extension StatisticsViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0: return 1
        case 1: return viewModel.runStatistics.count
        default: return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 0:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RunStatisticFilterCollectionViewCell", for: indexPath) as? RunStatisticFilterCollectionViewCell else {
                return UICollectionViewCell()
            }
            cell.delegate = self
            cell.runStatisticFilter = viewModel.selectedRunStatisticFilter
            return cell
        case 1:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RunStatisticCollectionViewCell", for: indexPath) as? RunStatisticCollectionViewCell else {
                return UICollectionViewCell()
            }
            cell.runStatistic = viewModel.runStatistics[indexPath.row]
            return cell
        default:
            return UICollectionViewCell()
        }
    }
    
}

extension StatisticsViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            break
        case 1:
            guard let statisticDetailViewController = storyboard?.instantiateViewController(withIdentifier: "RunStatisticDetailViewController") as? RunStatisticDetailViewController else {
                return
            }

            selectedCell = collectionView.cellForItem(at: indexPath) as? RunStatisticCollectionViewCell

            statisticDetailViewController.runStatistic = viewModel.runStatistics[indexPath.row]
            statisticDetailViewController.runs = viewModel.selectedRunStatisticFilter?.runs ?? []
            statisticDetailViewController.transitioningDelegate = self
            statisticDetailViewController.modalPresentationStyle = .fullScreen

            navigationController?.present(statisticDetailViewController, animated: true)
        default:
            break
        }
    }
    
}

extension StatisticsViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch indexPath.section {
        case 0:
            return CGSize(width: collectionView.frame.width - 32, height: 40)
        case 1:
            let width = collectionView.frame.width/2 - 16
            return CGSize(width: width, height: width * 0.75)
        default:
            return .zero
        }
    }
    
}

extension StatisticsViewController: UIViewControllerTransitioningDelegate {

    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let transition = RunStatisticsDetailTransition(statisticsCell: selectedCell!)
        
        return transition
    }

    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let transition = RunStatisticsDetailTransition(statisticsCell: selectedCell!)

        return transition
    }

}

extension StatisticsViewController: RunStatisticFilterCollectionViewCellDelegate {

    func runStatisticFilterCollectionViewCellDidPressButton(_ runStatisticFilterCollectionViewCell: RunStatisticFilterCollectionViewCell) {
        guard let filterNavigationController = storyboard?.instantiateViewController(withIdentifier: "FilterNavigationController") as? UINavigationController, let filterViewController = filterNavigationController.topViewController as? RunStatisticsFilterViewController else {
            return
        }

        filterViewController.delegate = self
        filterViewController.filters = viewModel.runStatisticFilters
        present(filterNavigationController, animated: true)
    }

}

extension StatisticsViewController: RunStatisticsFilterViewControllerDelegate {

    func runStatisticsFilterViewController(_ runStatisticsFilterViewController: RunStatisticsFilterViewController, didSelect filter: RunGroup) {
        runStatisticsFilterViewController.dismiss(animated: true)
        viewModel.selectedRunStatisticFilter = filter
    }

}
