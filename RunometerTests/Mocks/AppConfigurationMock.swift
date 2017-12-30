//
//  AppConfigurationMock.swift
//  RunometerTests
//
//  Created by Svante Dahlberg on 2017-12-28.
//  Copyright © 2017 Svante Dahlberg. All rights reserved.
//

import Foundation
@testable import Runometer

class AppConfigurationMock: AppConfiguration {
    
    override var distanceUnit: DistanceUnit { return .kilometers }
    override var speedUnit: SpeedUnit { return .minutesPerKilometer }
    
}
