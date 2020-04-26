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

    var chartData: [ChartDataSection] = [] {
        didSet {
            rootView = ChartView(dataSections: chartData)
        }
    }

    @objc required dynamic init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder, rootView: ChartView(dataSections: []))
    }
    
}
