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

    /// This date format is what decides what run goes in what section.
    /// Runs that return the same date will end up in the same section.
    /// It is not used to display a date, only for grouping runs by date.
    private static func dateFormatter(for filter: StatisticsBreakdownFilter) -> DateFormatter {
        let dateFormatter = DateFormatter()
        switch filter {
        case .allTime: dateFormatter.dateFormat = "yyyy"
        case .year: dateFormatter.dateFormat = "MMMM yyyy"
        case .quarter: dateFormatter.dateFormat = "MMMM yyyy w"
        case .month: dateFormatter.dateFormat = "MMMM yyyy d"
        case .week: dateFormatter.dateFormat = "MMMM yyyy w E"
        }
        return dateFormatter
    }
}
