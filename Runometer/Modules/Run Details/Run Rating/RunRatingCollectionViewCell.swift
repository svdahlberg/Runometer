//
//  RunRatingCollectionViewCell.swift
//  Runometer
//
//  Created by Svante Dahlberg on 2018-09-03.
//  Copyright © 2018 Svante Dahlberg. All rights reserved.
//

import UIKit

class RunRatingCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet private weak var runometerView: RunometerView!
    @IBOutlet private weak var descriptionLabel: UILabel!
    
    var runRating: RunRating? {
        didSet {
            guard let runRating = runRating else { return }
            runometerView.percentage = runRating.percentage
            runometerView.value = runRating.title
            runometerView.unitName = runRating.subtitle
            descriptionLabel.text = runRating.description
        }
    }

}
