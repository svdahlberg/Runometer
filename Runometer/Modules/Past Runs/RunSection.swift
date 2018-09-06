//
//  RunSection.swift
//  Runometer
//
//  Created by Svante Dahlberg on 2018-02-18.
//  Copyright © 2018 Svante Dahlberg. All rights reserved.
//

import Foundation

struct RunSection {
    let title: String
    let runs: [RunProtocol]
    
    static func runSections(from runs: [RunProtocol], titleDateFormatter: DateFormatter) -> [RunSection] {
        return Dictionary(grouping: runs) {
            titleDateFormatter.string(from: $0.endDate)
            }
            .map {
                RunSection(title: $0, runs: $1)
        }
    }
}
