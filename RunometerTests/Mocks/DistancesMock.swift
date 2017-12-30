//
//  DistancesMock.swift
//  RunometerTests
//
//  Created by Svante Dahlberg on 2017-12-26.
//  Copyright © 2017 Svante Dahlberg. All rights reserved.
//

import Foundation
@testable import Runometer

extension Meters {
    static func distancesMock() -> [Meters] {
        return [
            1000, 2000, 3000, 4000, 5000, 6000, 7000, 8000, 9000
        ]
    }
}
