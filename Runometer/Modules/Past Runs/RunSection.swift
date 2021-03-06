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
    
    static func runSections(from runs: [Run], filter: StatisticsBreakdownFilter, titleDateFormatter: DateFormatter? = nil) -> [RunSection] {
        return Dictionary(grouping: runs) {
            dateFormatter(for: filter).string(from: $0.endDate)
        }.map {
            let title: String
            if let titleDateFormatter = titleDateFormatter {
                title = titleDateFormatter.string(from: $1[0].endDate)
            } else {
                title = $0
            }
            return RunSection(title: title, runs: $1)
        }.sorted {
            guard $0.runs.count > 0, $1.runs.count > 0 else { return false }
            return $0.runs[0].endDate > $1.runs[0].endDate
        }
    }

    private static func dateFormatter(for filter: StatisticsBreakdownFilter) -> DateFormatter {
        let dateFormatter = DateFormatter()
        switch filter {
        case .year: dateFormatter.dateFormat = "yyyy"
        case .month: dateFormatter.dateFormat = "MMMM yyyy"
        case .week: dateFormatter.dateFormat = "MMMM yyyy w"
        }
        return dateFormatter
    }
}
