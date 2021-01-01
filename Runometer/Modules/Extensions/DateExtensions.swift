//
//  DateExtensions.swift
//  Runometer
//
//  Created by Svante Dahlberg on 11/29/20.
//  Copyright © 2020 Svante Dahlberg. All rights reserved.
//

import Foundation

extension Date {

    var startOfWeek: Date? {
        var calendar = Calendar.current
        calendar.firstWeekday = 2 // Monday
        var dateComponents = calendar.dateComponents([.weekOfYear, .yearForWeekOfYear], from: self)
        dateComponents.weekday = 2 // Monday
        return calendar.date(from: dateComponents)
    }

    var startOfMonth: Date? {
        let calendar = Calendar.current
        let dateComponents = calendar.dateComponents([.month, .year], from: self)
        return calendar.date(from: dateComponents)
    }

    var startOfYear: Date? {
        let calendar = Calendar.current
        let dateComponents = calendar.dateComponents([.year], from: self)
        return calendar.date(from: dateComponents)
    }

}
