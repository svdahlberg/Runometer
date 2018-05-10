//
//  SettingsMock.swift
//  RunometerTests
//
//  Created by Svante Dahlberg on 2017-11-19.
//  Copyright © 2017 Svante Dahlberg. All rights reserved.
//

import Foundation
@testable import Runometer


class SettingsMock: Settings {
    
    private var _distanceUnit: DistanceUnit
    private var _audioFeedbackDistance: Bool?
    private var _audioFeedbackTime: Bool?
    private var _audioFeedbackAveragePace: Bool?
    private var _audioTrigger: AudioTrigger
    private var _audioTimingInterval: Double
    
    init(distanceUnit: DistanceUnit, audioFeedbackDistance: Bool?, audioFeedbackTime: Bool?, audioFeedbackAveragePace: Bool?, audioTrigger: AudioTrigger, audioTimingInterval: Double) {
        _distanceUnit = distanceUnit
        _audioFeedbackDistance = audioFeedbackDistance
        _audioFeedbackTime = audioFeedbackTime
        _audioFeedbackAveragePace = audioFeedbackAveragePace
        _audioTrigger = audioTrigger
        _audioTimingInterval = audioTimingInterval
    }
    
    override var distanceUnit: DistanceUnit {
        get { return _distanceUnit }
        set {}
    }
    override var shouldGiveDistanceAudioFeedback: Bool {
        get { return _audioFeedbackDistance! }
        set {}
    }
    override var shouldGiveTimeAudioFeedback: Bool {
        get { return _audioFeedbackTime! }
        set {}
    }
    override var shouldGiveAveragePaceAudioFeedback: Bool {
        get { return _audioFeedbackAveragePace! }
        set {}
    }
    override var audioTrigger: AudioTrigger {
        get { return _audioTrigger }
        set {}
    }
    override var audioTimingInterval: Double {
        get { return _audioTimingInterval }
        set {}
    }
}
