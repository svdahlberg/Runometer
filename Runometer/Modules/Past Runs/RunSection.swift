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
    let runs: [Run]
    
    static func runSections(from runs: [Run], titleDateFormatter: DateFormatter) -> [RunSection] {
        return Dictionary(grouping: runs) {
            titleDateFormatter.string(from: $0.endDate)
        }.map {
            RunSection(title: $0, runs: $1)
        }.sorted {
            guard $0.runs.count > 0, $1.runs.count > 0 else { return false }
            return $0.runs[0].endDate > $1.runs[0].endDate
        }
    }
}
