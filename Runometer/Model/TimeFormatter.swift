//
//  TimeFormatter.swift
//  Runometer
//
//  Created by Svante Dahlberg on 2017-10-07.
//  Copyright © 2017 Svante Dahlberg. All rights reserved.
//

import Foundation

struct TimeFormatter {
    static func format(time: Seconds) -> String? {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute, .second]
        formatter.unitsStyle = .positional
        formatter.zeroFormattingBehavior = .pad
        return formatter.string(from: TimeInterval(time))
    }
}
