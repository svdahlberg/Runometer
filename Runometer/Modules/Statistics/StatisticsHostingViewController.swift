//
//  StatisticsHostingViewController.swift
//  Runometer
//
//  Created by Svante Dahlberg on 1/29/22.
//  Copyright © 2022 Svante Dahlberg. All rights reserved.
//

import UIKit
import SwiftUI

class StatisticsHostingViewController: UIHostingController<StatisticsView> {

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder, rootView: StatisticsView())
        navigationItem.title = "Statistics"
    }

}
