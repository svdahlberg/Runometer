//
//  DoubleExtensions.swift
//  Runometer
//
//  Created by Svante Dahlberg on 2017-11-19.
//  Copyright © 2017 Svante Dahlberg. All rights reserved.
//

import Foundation

extension Double {
    func trailingZeroRemoved() -> String {
        return String(format: "%g", self)
    }
}
