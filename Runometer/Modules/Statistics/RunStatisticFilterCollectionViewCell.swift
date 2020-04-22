//
//  RunStatisticFilterCollectionViewCell.swift
//  Runometer
//
//  Created by Svante Dahlberg on 4/19/20.
//  Copyright © 2020 Svante Dahlberg. All rights reserved.
//

import UIKit

protocol RunStatisticFilterCollectionViewCellDelegate: AnyObject {
    func runStatisticFilterCollectionViewCellDidPressButton(_ runStatisticFilterCollectionViewCell: RunStatisticFilterCollectionViewCell)
}

class RunStatisticFilterCollectionViewCell: UICollectionViewCell {

    @IBOutlet private weak var button: UIButton!

    var runStatisticFilter: RunGroup? {
        didSet {
            guard let runStatisticFilter = runStatisticFilter else { return }
            button.setTitle("Show statistics for \(runStatisticFilter.name)", for: .normal)
        }
    }

    weak var delegate: RunStatisticFilterCollectionViewCellDelegate?
    
    @IBAction private func didPressButton(_ sender: Any) {
        delegate?.runStatisticFilterCollectionViewCellDidPressButton(self)
    }

}
