//
//  SettingsMock.swift
//  RunometerTests
//
//  Created by Svante Dahlberg on 2017-11-19.
//  Copyright © 2017 Svante Dahlberg. All rights reserved.
//

import Foundation
@testable import Runometer

struct SettingsMock: SettingsProvider {
    var distanceUnit: DistanceUnit?
    var audioFeedbackDistance: Bool?
    var audioFeedbackTime: Bool?
    var audioFeedbackAveragePace: Bool?
    var audioFeedbackSplitPace: Bool?
    var audioTrigger: AudioTrigger?
    var audioTimingInterval: Double?
}
