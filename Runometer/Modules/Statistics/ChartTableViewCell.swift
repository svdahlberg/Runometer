//
//  ChartTableViewCell.swift
//  Runometer
//
//  Created by Svante Dahlberg on 2/6/21.
//  Copyright © 2021 Svante Dahlberg. All rights reserved.
//

import UIKit
import SwiftUI

class ChartTableViewCell: UITableViewCell {

    private var chartHostingController: UIHostingController<ChartView>?

    var chartModel: ChartModel? {
        didSet {
            guard let chartModel = chartModel else {
                return
            }

            if let chartHostingController = chartHostingController {
                chartHostingController.rootView = ChartView(chartModel: chartModel)
            } else {
                let chartHostingController = UIHostingController<ChartView>(rootView: ChartView(chartModel: chartModel))
                contentView.addSubview(chartHostingController.view)
                chartHostingController.view.pinToSuperview(leading: 16, top: 30, trailing: -16, bottom: -80)
                chartHostingController.view.heightAnchor.constraint(equalToConstant: 250).isActive = true

                self.chartHostingController = chartHostingController
            }

            contentView.layoutIfNeeded()
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        chartHostingController?.view.removeFromSuperview()
        chartHostingController = nil
    }

}
