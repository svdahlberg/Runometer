//
//  ChartViewHostingController.swift
//  Runometer
//
//  Created by Svante Dahlberg on 4/25/20.
//  Copyright © 2020 Svante Dahlberg. All rights reserved.
//

import UIKit
import SwiftUI

class ChartViewHostingController: UIHostingController<ChartView> {

    var chartModel: ChartModel? {
        didSet {
            guard let chartModel = chartModel else { return }
            rootView = ChartView(chartModel: chartModel)
        }
    }

    @objc required dynamic init?(coder aDecoder: NSCoder) {
        let chartModel = ChartModel(dataSections: [], valueFormatter: { _ in "" }, pagingEnabled: true)
        super.init(coder: aDecoder, rootView: ChartView(chartModel: chartModel))
    }
    
}
