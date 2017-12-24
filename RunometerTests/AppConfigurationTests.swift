//
//  AppConfigurationTests.swift
//  RunometerTests
//
//  Created by Svante Dahlberg on 2017-11-19.
//  Copyright © 2017 Svante Dahlberg. All rights reserved.
//

import XCTest
@testable import Runometer

class AppConfigurationTests: XCTestCase {
    
    private var sut: AppConfiguration!
    
    override func setUp() {
        super.setUp()
        sut = AppConfiguration(settings: SettingsMock())
    }
    
    func testDistanceUnitReturnsKilometersIfValueInSettingsIsNil() {
        XCTAssertEqual(DistanceUnit.kilometers, sut.distanceUnit)
    }
    
    func testAudioTriggerReturnsDistanceIfAudioTriggerInSettingsIsNil() {
        XCTAssertEqual(AudioTrigger.distance, sut.audioTrigger)
    }
    
    func testShouldGiveDistanceAudioFeedbackReturnsTrueIfValueInSettingsIsNil() {
        XCTAssertTrue(sut.shouldGiveDistanceAudioFeedback)
    }
    
    func testShouldGiveTimeAudioFeedbackReturnsTrueIfValueInSettingsIsNil() {
        XCTAssertTrue(sut.shouldGiveTimeAudioFeedback)
    }
    
    func testShouldGiveAveragePaceAudioFeedbackReturnsTrueIfValueInSettingsIsNil() {
        XCTAssertTrue(sut.shouldGiveAveragePaceAudioFeedback)
    }
    
    func testShouldGiveSplitPaceAudioFeedbackReturnsFalseIfValueInSettingsIsNil() {
        XCTAssertFalse(sut.shouldGiveSplitPaceAudioFeedback)
    }
    
    func testAudioTimingIntervalReturns5IfAudioTimingINtervalInSettingsIsNilAndAudioTriggerIsTime() {
        let settingsMock = SettingsMock(distanceUnit: nil, audioFeedbackDistance: nil, audioFeedbackTime: nil, audioFeedbackAveragePace: nil, audioFeedbackSplitPace: nil, audioTrigger: .time, audioTimingInterval: nil)
        sut = AppConfiguration(settings: settingsMock)
        XCTAssertEqual(5, sut.audioTimingInterval)
    }
    
    func testAudioTimingIntervalReturns1IfAudioTimingINtervalInSettingsIsNilAndAudioTriggerIsDistance() {
        XCTAssertEqual(1, sut.audioTimingInterval)
    }
    
    func testAudioIntervalsReturnsTimeIntervalsIfAudioTriggerIsTime() {
        let sut = AppConfiguration(settings: SettingsMock(distanceUnit: nil, audioFeedbackDistance: nil, audioFeedbackTime: nil, audioFeedbackAveragePace: nil, audioFeedbackSplitPace: nil, audioTrigger: .time, audioTimingInterval: nil))
        XCTAssertEqual(sut.timeIntervals, sut.audioIntervals)
    }
    
    func testAudioIntervalsReturnsKilometerIntervalsIfAudioTriggerIsDistanceAndDistanceUnitIsKilometers() {
        XCTAssertEqual(sut.kilometerIntervals, sut.audioIntervals)
    }
    
    func testAudioIntervalsReturnsMilesIntervalsIfAudioTriggerIsDistanceAndDistanceUnitIsMiles() {
        let sut = AppConfiguration(settings: SettingsMock(distanceUnit: .miles, audioFeedbackDistance: nil, audioFeedbackTime: nil, audioFeedbackAveragePace: nil, audioFeedbackSplitPace: nil, audioTrigger: .distance, audioTimingInterval: nil))
        XCTAssertEqual(sut.mileIntervals, sut.audioIntervals)
    }
    
}
