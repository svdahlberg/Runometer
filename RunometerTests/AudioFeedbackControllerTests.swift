//
//  AudioFeedbackControllerTests.swift
//  RunometerTests
//
//  Created by Svante Dahlberg on 2018-01-28.
//  Copyright © 2018 Svante Dahlberg. All rights reserved.
//

import XCTest
@testable import Runometer

class AudioFeedbackControllerTests: XCTestCase {

    func testDistanceTimeAndValueAtLastAudioFeedbcakAreInitializedToZero() {
        let audioFeedbackController = AudioFeedbackController(settings: settingsMock(audioTrigger: .time))
        XCTAssertEqual(0, audioFeedbackController.distance)
        XCTAssertEqual(0, audioFeedbackController.time)
        XCTAssertEqual(0, audioFeedbackController.valueAtLastAudioFeedback)
    }
    
    func testValueAtNextAudioFeedback_whenInitializedAndAudioTriggerIsTime_returnsAudioFeedbackIntervalTimesSixty() {
        var audioFeedbackController = AudioFeedbackController(settings: settingsMock(audioTrigger: .time))
        XCTAssertEqual(60, audioFeedbackController.valueAtNextAudioFeedback)
    }
    
    func testValueAtNextAudioFeedback_whenInitializedAndAudioTriggerIsDistance_returnsAudioFeedbackIntervalTimesNUmberOfMetersInDistanceUnit() {
        var audioFeedbackController = AudioFeedbackController(settings: settingsMock(audioTrigger: .distance))
        XCTAssertEqual(1000, audioFeedbackController.valueAtNextAudioFeedback)
    }
    
    func testValueAtLastAudioFeedback_afterSettingTimeToAValueGreaterThanAudioFeedbackInterval_isIncreasedByValueOfAudioFeedbackInterval() {
        var audioFeedbackController = AudioFeedbackController(settings: settingsMock(audioTrigger: .time))
        audioFeedbackController.time = 60
        XCTAssertEqual(60, audioFeedbackController.valueAtLastAudioFeedback)
    }
    
    func testValueAtLastAudioFeedback_afterSettingDistanceToAValueGreaterThanAudioFeedbackInterval_isIncreasedByValueOfAudioFeedbackInterval() {
        var audioFeedbackController = AudioFeedbackController(settings: settingsMock(audioTrigger: .distance))
        audioFeedbackController.distance = 1000
        XCTAssertEqual(1000, audioFeedbackController.valueAtLastAudioFeedback)
    }
    
    func testSettingDistance_whenAudioTriggerIsTime_doesNothing() {
        var audioFeedbackController = AudioFeedbackController(settings: settingsMock(audioTrigger: .time))
        audioFeedbackController.distance = 1000
        XCTAssertEqual(0, audioFeedbackController.valueAtLastAudioFeedback)
        XCTAssertEqual(60, audioFeedbackController.valueAtNextAudioFeedback)
    }
    
    func testSettingTime_whenAudioTriggerIsDistance_doesNothing() {
        var audioFeedbackController = AudioFeedbackController(settings: settingsMock(audioTrigger: .distance))
        audioFeedbackController.time = 60
        XCTAssertEqual(0, audioFeedbackController.valueAtLastAudioFeedback)
        XCTAssertEqual(1000, audioFeedbackController.valueAtNextAudioFeedback)
    }
    
}

extension AudioFeedbackControllerTests {
    private func settingsMock(audioTrigger: AudioTrigger) -> Settings {
        return SettingsMock(distanceUnit: .kilometers, audioFeedbackDistance: true, audioFeedbackTime: true, audioFeedbackAveragePace: true, audioTrigger: audioTrigger, audioTimingInterval: 1)
    }
}

