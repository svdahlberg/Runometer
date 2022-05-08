//
//  MockRunProvider.swift
//  Runometer
//
//  Created by Svante Dahlberg on 4/10/21.
//  Copyright © 2021 Svante Dahlberg. All rights reserved.
//

import Foundation

struct MockRunProvider: RunProviding {

    func runs(filter: RunFilter?, completion: @escaping ([Run]) -> Void) {
        completion(runs)
    }

    var runs: [Run] {
        [
            // April 2021
            RunMock(distance: 10000, duration: Seconds.oneHour, startDate: Date.date(year: 2021, month: 4)!, endDate: Date.date(year: 2021, month: 4, day: 2)!),
            RunMock(distance: 4500, duration: Seconds.oneHour / 3, startDate: Date.date(year: 2021, month: 4)!, endDate: Date.date(year: 2021, month: 4, day: 5)!),
            RunMock(distance: 6310, duration: Seconds.oneHour / 2, startDate: Date.date(year: 2021, month: 4)!, endDate: Date.date(year: 2021, month: 4, day: 12)!),
            RunMock(distance: 6210, duration: Seconds.oneHour / 2, startDate: Date.date(year: 2021, month: 4)!, endDate: Date.date(year: 2021, month: 4, day: 15)!),
            // March 2021
            RunMock(distance: 10070, duration: Seconds.oneHour, startDate: Date.date(year: 2021, month: 3)!, endDate: Date.date(year: 2021, month: 3, day: 1)!),
            RunMock(distance: 12100, duration: Seconds.oneHour, startDate: Date.date(year: 2021, month: 3)!, endDate: Date.date(year: 2021, month: 3, day: 10)!),
            RunMock(distance: 12050, duration: Seconds.oneHour, startDate: Date.date(year: 2021, month: 3)!, endDate: Date.date(year: 2021, month: 3, day: 12)!),
            RunMock(distance: 4500, duration: Seconds.oneHour / 3, startDate: Date.date(year: 2021, month: 3)!, endDate: Date.date(year: 2021, month: 3, day: 15)!),
            RunMock(distance: 6230, duration: Seconds.oneHour / 2, startDate: Date.date(year: 2021, month: 3)!, endDate: Date.date(year: 2021, month: 3, day: 16)!),
            RunMock(distance: 6290, duration: Seconds.oneHour / 2, startDate: Date.date(year: 2021, month: 3)!, endDate: Date.date(year: 2021, month: 3, day: 18)!),
            RunMock(distance: 6400, duration: Seconds.oneHour / 2, startDate: Date.date(year: 2021, month: 3)!, endDate: Date.date(year: 2021, month: 3, day: 23)!),
            RunMock(distance: 6210, duration: Seconds.oneHour / 2, startDate: Date.date(year: 2021, month: 3)!, endDate: Date.date(year: 2021, month: 3, day: 28)!),
            // February 2021
            RunMock(distance: 10300, duration: Seconds.oneHour, startDate: Date.date(year: 2021, month: 2)!, endDate: Date.date(year: 2021, month: 2)!),
            RunMock(distance: 10000, duration: Seconds.oneHour, startDate: Date.date(year: 2021, month: 2)!, endDate: Date.date(year: 2021, month: 2)!),
            RunMock(distance: 4520, duration: Seconds.oneHour / 3, startDate: Date.date(year: 2021, month: 2)!, endDate: Date.date(year: 2021, month: 2)!),
            RunMock(distance: 4500, duration: Seconds.oneHour / 3, startDate: Date.date(year: 2021, month: 2)!, endDate: Date.date(year: 2021, month: 2)!),
            RunMock(distance: 4500, duration: Seconds.oneHour / 3, startDate: Date.date(year: 2021, month: 2)!, endDate: Date.date(year: 2021, month: 2)!),
            RunMock(distance: 6210, duration: Seconds.oneHour / 2, startDate: Date.date(year: 2021, month: 2)!, endDate: Date.date(year: 2021, month: 2)!),
            RunMock(distance: 6210, duration: Seconds.oneHour / 2, startDate: Date.date(year: 2021, month: 2)!, endDate: Date.date(year: 2021, month: 2)!),
            // January 2021
            RunMock(distance: 12000, duration: Seconds.oneHour, startDate: Date.date(year: 2021, month: 1)!, endDate: Date.date(year: 2021, month: 1)!),
            RunMock(distance: 4500, duration: Seconds.oneHour / 3, startDate: Date.date(year: 2021, month: 1)!, endDate: Date.date(year: 2021, month: 1)!),
            RunMock(distance: 6120, duration: Seconds.oneHour / 2, startDate: Date.date(year: 2021, month: 1)!, endDate: Date.date(year: 2021, month: 1)!),
            RunMock(distance: 6250, duration: Seconds.oneHour / 2, startDate: Date.date(year: 2021, month: 1)!, endDate: Date.date(year: 2021, month: 1)!),
            RunMock(distance: 6210, duration: Seconds.oneHour / 2, startDate: Date.date(year: 2021, month: 1)!, endDate: Date.date(year: 2021, month: 1)!),
            // December 2020
            RunMock(distance: 12000, duration: Seconds.oneHour, startDate: Date.date(year: 2020, month: 12)!, endDate: Date.date(year: 2020, month: 12)!),
            RunMock(distance: 4500, duration: Seconds.oneHour / 3, startDate: Date.date(year: 2020, month: 12)!, endDate: Date.date(year: 2020, month: 12)!),
            RunMock(distance: 6210, duration: Seconds.oneHour / 2, startDate: Date.date(year: 2020, month: 12)!, endDate: Date.date(year: 2020, month: 12)!),
            RunMock(distance: 6210, duration: Seconds.oneHour / 2, startDate: Date.date(year: 2020, month: 12)!, endDate: Date.date(year: 2020, month: 12)!),
            RunMock(distance: 6210, duration: Seconds.oneHour / 2, startDate: Date.date(year: 2020, month: 12)!, endDate: Date.date(year: 2020, month: 12)!),
            // November 2020
            RunMock(distance: 12000, duration: Seconds.oneHour, startDate: Date.date(year: 2020, month: 11)!, endDate: Date.date(year: 2020, month: 11)!),
            RunMock(distance: 12000, duration: Seconds.oneHour, startDate: Date.date(year: 2020, month: 11)!, endDate: Date.date(year: 2020, month: 11)!),
            RunMock(distance: 4600, duration: Seconds.oneHour / 3, startDate: Date.date(year: 2020, month: 11)!, endDate: Date.date(year: 2020, month: 11)!),
            RunMock(distance: 6210, duration: Seconds.oneHour / 2, startDate: Date.date(year: 2020, month: 11)!, endDate: Date.date(year: 2020, month: 11)!),
            RunMock(distance: 6210, duration: Seconds.oneHour / 2, startDate: Date.date(year: 2020, month: 11)!, endDate: Date.date(year: 2020, month: 11)!),
            RunMock(distance: 6210, duration: Seconds.oneHour / 2, startDate: Date.date(year: 2020, month: 11)!, endDate: Date.date(year: 2020, month: 11)!),
            // October 2020
            RunMock(distance: 12000, duration: Seconds.oneHour, startDate: Date.date(year: 2020, month: 10)!, endDate: Date.date(year: 2020, month: 10)!),
            RunMock(distance: 12000, duration: Seconds.oneHour, startDate: Date.date(year: 2020, month: 10)!, endDate: Date.date(year: 2020, month: 10)!),
            RunMock(distance: 12000, duration: Seconds.oneHour, startDate: Date.date(year: 2020, month: 10)!, endDate: Date.date(year: 2020, month: 10)!),
            RunMock(distance: 4500, duration: Seconds.oneHour / 3, startDate: Date.date(year: 2020, month: 10)!, endDate: Date.date(year: 2020, month: 10)!),
            RunMock(distance: 6210, duration: Seconds.oneHour / 2, startDate: Date.date(year: 2020, month: 10)!, endDate: Date.date(year: 2020, month: 10)!),
            RunMock(distance: 6210, duration: Seconds.oneHour / 2, startDate: Date.date(year: 2020, month: 10)!, endDate: Date.date(year: 2020, month: 10)!),
            RunMock(distance: 6210, duration: Seconds.oneHour / 2, startDate: Date.date(year: 2020, month: 10)!, endDate: Date.date(year: 2020, month: 10)!),
            // September 2020
            RunMock(distance: 12000, duration: Seconds.oneHour, startDate: Date.date(year: 2020, month: 9)!, endDate: Date.date(year: 2020, month: 9)!),
            RunMock(distance: 12000, duration: Seconds.oneHour, startDate: Date.date(year: 2020, month: 9)!, endDate: Date.date(year: 2020, month: 9)!),
            RunMock(distance: 21000, duration: Seconds.oneHour * 2, startDate: Date.date(year: 2020, month: 5)!, endDate: Date.date(year: 2020, month: 5)!),
            RunMock(distance: 4500, duration: Seconds.oneHour / 3, startDate: Date.date(year: 2020, month: 9)!, endDate: Date.date(year: 2020, month: 9)!),
            RunMock(distance: 6210, duration: Seconds.oneHour / 2, startDate: Date.date(year: 2020, month: 9)!, endDate: Date.date(year: 2020, month: 9)!),
            RunMock(distance: 6210, duration: Seconds.oneHour / 2, startDate: Date.date(year: 2020, month: 9)!, endDate: Date.date(year: 2020, month: 9)!),
            RunMock(distance: 6210, duration: Seconds.oneHour / 2, startDate: Date.date(year: 2020, month: 9)!, endDate: Date.date(year: 2020, month: 9)!),
            // August 2020
            RunMock(distance: 12000, duration: Seconds.oneHour, startDate: Date.date(year: 2020, month: 8)!, endDate: Date.date(year: 2020, month: 8)!),
            RunMock(distance: 12000, duration: Seconds.oneHour, startDate: Date.date(year: 2020, month: 8)!, endDate: Date.date(year: 2020, month: 8)!),
            RunMock(distance: 10000, duration: Seconds.oneHour, startDate: Date.date(year: 2020, month: 8)!, endDate: Date.date(year: 2020, month: 8)!),
            RunMock(distance: 10000, duration: Seconds.oneHour, startDate: Date.date(year: 2020, month: 8)!, endDate: Date.date(year: 2020, month: 8)!),
            RunMock(distance: 4500, duration: Seconds.oneHour / 3, startDate: Date.date(year: 2020, month: 8)!, endDate: Date.date(year: 2020, month: 8)!),
            RunMock(distance: 4500, duration: Seconds.oneHour / 3, startDate: Date.date(year: 2020, month: 8)!, endDate: Date.date(year: 2020, month: 8)!),
            RunMock(distance: 6210, duration: Seconds.oneHour / 2, startDate: Date.date(year: 2020, month: 8)!, endDate: Date.date(year: 2020, month: 8)!),
            RunMock(distance: 6210, duration: Seconds.oneHour / 2, startDate: Date.date(year: 2020, month: 8)!, endDate: Date.date(year: 2020, month: 8)!),
            RunMock(distance: 6210, duration: Seconds.oneHour / 2, startDate: Date.date(year: 2020, month: 8)!, endDate: Date.date(year: 2020, month: 8)!),
            // July 2020
            RunMock(distance: 12000, duration: Seconds.oneHour, startDate: Date.date(year: 2020, month: 7)!, endDate: Date.date(year: 2020, month: 7)!),
            RunMock(distance: 12000, duration: Seconds.oneHour, startDate: Date.date(year: 2020, month: 7)!, endDate: Date.date(year: 2020, month: 7)!),
            RunMock(distance: 12000, duration: Seconds.oneHour, startDate: Date.date(year: 2020, month: 7)!, endDate: Date.date(year: 2020, month: 7)!),
            RunMock(distance: 12000, duration: Seconds.oneHour, startDate: Date.date(year: 2020, month: 7)!, endDate: Date.date(year: 2020, month: 7)!),
            RunMock(distance: 4500, duration: Seconds.oneHour / 3, startDate: Date.date(year: 2020, month: 7)!, endDate: Date.date(year: 2020, month: 7)!),
            RunMock(distance: 6210, duration: Seconds.oneHour / 2, startDate: Date.date(year: 2020, month: 7)!, endDate: Date.date(year: 2020, month: 7)!),
            RunMock(distance: 6210, duration: Seconds.oneHour / 2, startDate: Date.date(year: 2020, month: 7)!, endDate: Date.date(year: 2020, month: 7)!),
            RunMock(distance: 6210, duration: Seconds.oneHour / 2, startDate: Date.date(year: 2020, month: 7)!, endDate: Date.date(year: 2020, month: 7)!),
            RunMock(distance: 6210, duration: Seconds.oneHour / 2, startDate: Date.date(year: 2020, month: 7)!, endDate: Date.date(year: 2020, month: 7)!),
            RunMock(distance: 6210, duration: Seconds.oneHour / 2, startDate: Date.date(year: 2020, month: 7)!, endDate: Date.date(year: 2020, month: 7)!),
            // June 2020
            RunMock(distance: 12000, duration: Seconds.oneHour, startDate: Date.date(year: 2020, month: 6)!, endDate: Date.date(year: 2020, month: 6)!),
            RunMock(distance: 12000, duration: Seconds.oneHour, startDate: Date.date(year: 2020, month: 6)!, endDate: Date.date(year: 2020, month: 6)!),
            RunMock(distance: 12000, duration: Seconds.oneHour, startDate: Date.date(year: 2020, month: 6)!, endDate: Date.date(year: 2020, month: 6)!),
            RunMock(distance: 4500, duration: Seconds.oneHour / 3, startDate: Date.date(year: 2020, month: 6)!, endDate: Date.date(year: 2020, month: 6)!),
            RunMock(distance: 6210, duration: Seconds.oneHour / 2, startDate: Date.date(year: 2020, month: 6)!, endDate: Date.date(year: 2020, month: 6)!),
            RunMock(distance: 6210, duration: Seconds.oneHour / 2, startDate: Date.date(year: 2020, month: 6)!, endDate: Date.date(year: 2020, month: 6)!),
            RunMock(distance: 6210, duration: Seconds.oneHour / 2, startDate: Date.date(year: 2020, month: 6)!, endDate: Date.date(year: 2020, month: 6)!),
            RunMock(distance: 6210, duration: Seconds.oneHour / 2, startDate: Date.date(year: 2020, month: 6)!, endDate: Date.date(year: 2020, month: 6)!),
            RunMock(distance: 6210, duration: Seconds.oneHour / 2, startDate: Date.date(year: 2020, month: 6)!, endDate: Date.date(year: 2020, month: 6)!),
            // May 2020
            RunMock(distance: 12000, duration: Seconds.oneHour, startDate: Date.date(year: 2020, month: 5)!, endDate: Date.date(year: 2020, month: 5)!),
            RunMock(distance: 12000, duration: Seconds.oneHour, startDate: Date.date(year: 2020, month: 5)!, endDate: Date.date(year: 2020, month: 5)!),
            RunMock(distance: 12000, duration: Seconds.oneHour, startDate: Date.date(year: 2020, month: 5)!, endDate: Date.date(year: 2020, month: 5)!),
            RunMock(distance: 21000, duration: Seconds.oneHour * 2, startDate: Date.date(year: 2020, month: 5)!, endDate: Date.date(year: 2020, month: 5)!),
            RunMock(distance: 4500, duration: Seconds.oneHour / 3, startDate: Date.date(year: 2020, month: 5)!, endDate: Date.date(year: 2020, month: 5)!),
            RunMock(distance: 6210, duration: Seconds.oneHour / 2, startDate: Date.date(year: 2020, month: 5)!, endDate: Date.date(year: 2020, month: 5)!),
            RunMock(distance: 6210, duration: Seconds.oneHour / 2, startDate: Date.date(year: 2020, month: 5)!, endDate: Date.date(year: 2020, month: 5)!),
            RunMock(distance: 6210, duration: Seconds.oneHour / 2, startDate: Date.date(year: 2020, month: 5)!, endDate: Date.date(year: 2020, month: 5)!),
            RunMock(distance: 6210, duration: Seconds.oneHour / 2, startDate: Date.date(year: 2020, month: 5)!, endDate: Date.date(year: 2020, month: 5)!),
            // April 2020
            RunMock(distance: 12000, duration: Seconds.oneHour, startDate: Date.date(year: 2020, month: 4)!, endDate: Date.date(year: 2020, month: 4, day: 3)!),
            RunMock(distance: 12000, duration: Seconds.oneHour, startDate: Date.date(year: 2020, month: 4)!, endDate: Date.date(year: 2020, month: 4, day: 4)!),
            RunMock(distance: 12000, duration: Seconds.oneHour, startDate: Date.date(year: 2020, month: 4)!, endDate: Date.date(year: 2020, month: 4, day: 7)!),
            RunMock(distance: 4500, duration: Seconds.oneHour / 3, startDate: Date.date(year: 2020, month: 4)!, endDate: Date.date(year: 2020, month: 4, day: 12)!),
            RunMock(distance: 6210, duration: Seconds.oneHour / 2, startDate: Date.date(year: 2020, month: 4)!, endDate: Date.date(year: 2020, month: 4, day: 15)!),
            RunMock(distance: 6210, duration: Seconds.oneHour / 2, startDate: Date.date(year: 2020, month: 4)!, endDate: Date.date(year: 2020, month: 4, day: 16)!),
            RunMock(distance: 6210, duration: Seconds.oneHour / 2, startDate: Date.date(year: 2020, month: 4)!, endDate: Date.date(year: 2020, month: 4, day: 19)!),
            RunMock(distance: 6210, duration: Seconds.oneHour / 2, startDate: Date.date(year: 2020, month: 4)!, endDate: Date.date(year: 2020, month: 4, day: 25)!),
            RunMock(distance: 12000, duration: Seconds.oneHour, startDate: Date.date(year: 2020, month: 4)!, endDate: Date.date(year: 2020, month: 4, day: 29)!),
            RunMock(distance: 12000, duration: Seconds.oneHour, startDate: Date.date(year: 2020, month: 4)!, endDate: Date.date(year: 2020, month: 4, day: 30)!),
            // March 2020
            RunMock(distance: 4500, duration: Seconds.oneHour / 3, startDate: Date.date(year: 2020, month: 3)!, endDate: Date.date(year: 2020, month: 3, day: 1)!),
            RunMock(distance: 6210, duration: Seconds.oneHour / 2, startDate: Date.date(year: 2020, month: 3)!, endDate: Date.date(year: 2020, month: 3, day: 12)!),
            RunMock(distance: 6210, duration: Seconds.oneHour / 2, startDate: Date.date(year: 2020, month: 3)!, endDate: Date.date(year: 2020, month: 3, day: 13)!),
            RunMock(distance: 6210, duration: Seconds.oneHour / 2, startDate: Date.date(year: 2020, month: 3)!, endDate: Date.date(year: 2020, month: 3, day: 14)!),
            // February 2020
            RunMock(distance: 12000, duration: Seconds.oneHour, startDate: Date.date(year: 2020, month: 2)!, endDate: Date.date(year: 2020, month: 2, day: 2)!),
            RunMock(distance: 4500, duration: Seconds.oneHour / 3, startDate: Date.date(year: 2020, month: 2)!, endDate: Date.date(year: 2020, month: 2, day: 10)!),
            RunMock(distance: 6210, duration: Seconds.oneHour / 2, startDate: Date.date(year: 2020, month: 2)!, endDate: Date.date(year: 2020, month: 2, day: 11)!),
            RunMock(distance: 6210, duration: Seconds.oneHour / 2, startDate: Date.date(year: 2020, month: 2)!, endDate: Date.date(year: 2020, month: 2, day: 15)!),
            RunMock(distance: 6210, duration: Seconds.oneHour / 2, startDate: Date.date(year: 2020, month: 2)!, endDate: Date.date(year: 2020, month: 2, day: 20)!),
            RunMock(distance: 6210, duration: Seconds.oneHour / 2, startDate: Date.date(year: 2020, month: 2)!, endDate: Date.date(year: 2020, month: 2, day: 28)!),
            // January 2020
            RunMock(distance: 12000, duration: Seconds.oneHour, startDate: Date.date(year: 2020, month: 1)!, endDate: Date.date(year: 2020, month: 1, day: 1)!),
            RunMock(distance: 4500, duration: Seconds.oneHour / 3, startDate: Date.date(year: 2020, month: 1)!, endDate: Date.date(year: 2020, month: 1, day: 4)!),
            RunMock(distance: 6210, duration: Seconds.oneHour / 2, startDate: Date.date(year: 2020, month: 1)!, endDate: Date.date(year: 2020, month: 1, day: 5)!),
            RunMock(distance: 6210, duration: Seconds.oneHour / 2, startDate: Date.date(year: 2020, month: 1)!, endDate: Date.date(year: 2020, month: 1, day: 10)!),
            RunMock(distance: 6210, duration: Seconds.oneHour / 2, startDate: Date.date(year: 2020, month: 1)!, endDate: Date.date(year: 2020, month: 1, day: 17)!),

            // December 2019
            RunMock(distance: 4500, duration: Seconds.oneHour / 3, startDate: Date.date(year: 2019, month: 12)!, endDate: Date.date(year: 2019, month: 12, day: 10)!),
        ]
    }

}
