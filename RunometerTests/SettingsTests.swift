//
//  SettingsTests.swift
//  RunometerTests
//
//  Created by Svante Dahlberg on 2018-05-10.
//  Copyright © 2018 Svante Dahlberg. All rights reserved.
//

import XCTest
@testable import Runometer

class SettingsTests: XCTestCase {
    
    private var sut: Settings!
    private var userDefaultsMock: UserDefaultsMock!
    
    override func setUp() {
        super.setUp()
        userDefaultsMock = UserDefaultsMock()
        sut = Settings(userDefaults: userDefaultsMock)
    }
    
    override func tearDown() {
        sut = nil
        userDefaultsMock = nil
        super.tearDown()
    }
    
    // MARK: distanceUnit
    
    func testGetDistanceUnit_shouldInvokeStringForKeyWithDistanceUnitKeyOnUserDefaults() {
        // When
        let _ = sut.distanceUnit
        
        // Then
        XCTAssertEqual(userDefaultsMock.stringForKeyInvokeCount, 1)
        XCTAssertEqual(userDefaultsMock.stringForKeyArgument, Settings.UserDefaultKey.distanceUnit.rawValue)
    }

    func testGetDistanceUnit_withUserDefaultsStringForKeyReturningStringKm_shouldReturnKilometers() {
        // Given
        userDefaultsMock.stringForKeyReturnValue = "km"
        sut = Settings(userDefaults: userDefaultsMock)
        
        // When
        let distanceUnit = sut.distanceUnit
        
        // Then
        XCTAssertEqual(distanceUnit, .kilometers)
    }
    
    func testGetDistanceUnit_withUserDefaultsStringForKeyReturningStringMi_shouldReturnMiles() {
        // Given
        userDefaultsMock.stringForKeyReturnValue = "mi"
        sut = Settings(userDefaults: userDefaultsMock)
        
        // When
        let distanceUnit = sut.distanceUnit
        
        // Then
        XCTAssertEqual(distanceUnit, .miles)
    }
    
    func testGetDistanceUnit_withUserDefaultsStringForKeyReturningNil_shouldReturnKilometers() {
        // When
        let distanceUnit = sut.distanceUnit
        
        // Then
        XCTAssertEqual(distanceUnit, .kilometers)
    }
    
    func testGetDistanceUnit_withUserDefaultsStringForKeyReturningStringThatIsNotKmOrMi_shouldReturnKilometers() {
        // Given
        userDefaultsMock.stringForKeyReturnValue = "randomString"
        sut = Settings(userDefaults: userDefaultsMock)
        
        // When
        let distanceUnit = sut.distanceUnit
        
        // Then
        XCTAssertEqual(distanceUnit, .kilometers)
    }
    
    func testSetDistanceUnit_shouldInvokeSetOnUserDefaultsWithKeyDistanceUnit() {
        // When
        sut.distanceUnit = .kilometers
        
        // Then
        XCTAssertEqual(userDefaultsMock.setInvokeCount, 1)
        XCTAssertEqual(userDefaultsMock.setKeyArgument, Settings.UserDefaultKey.distanceUnit.rawValue)
    }
    
    func testSetDistanceUnit_toKilometers_shouldInvokeSetOnUserDefaultsWithValueStringKm() {
        // When
        sut.distanceUnit = .kilometers
        
        // Then
        XCTAssertEqual(userDefaultsMock.setValueArgument as? String, "km")
    }
    
    func testSetDistanceUnit_toMiles_shouldInvokeSetOnUserDefaultsWithValueStringMi() {
        // When
        sut.distanceUnit = .miles
        
        // Then
        XCTAssertEqual(userDefaultsMock.setValueArgument as? String, "mi")
    }
    
    // MARK: speedUnit
    
    func testSpeedUnit_withUserDefaultsStringForKeyDistanceUnitReturningKm_shouldReturnMinutesPerKilometer() {
        // Given
        userDefaultsMock.stringForKeyReturnValue = "km"
        sut = Settings(userDefaults: userDefaultsMock)
        
        // When
        let speedUnit = sut.speedUnit
        
        // Then
        XCTAssertEqual(speedUnit, .minutesPerKilometer)
    }
    
    func testSpeedUnit_withUserDefaultsStringForKeyDistanceUnitReturningMi_shouldReturnMinutesPerMil() {
        // Given
        userDefaultsMock.stringForKeyReturnValue = "mi"
        sut = Settings(userDefaults: userDefaultsMock)
        
        // When
        let speedUnit = sut.speedUnit
        
        // Then
        XCTAssertEqual(speedUnit, .minutesPerMile)
    }
    
    // MARK: audioTrigger
    
    func testGetAudioTrigger_shouldInvokeStringForKeyWithAudioTriggerKeyOnUserDefaults() {
        // When
        let _ = sut.audioTrigger
        
        // Then
        XCTAssertEqual(userDefaultsMock.stringForKeyInvokeCount, 1)
        XCTAssertEqual(userDefaultsMock.stringForKeyArgument, Settings.UserDefaultKey.audioTrigger.rawValue)
    }
    
    func testGetAudioTrigger_withUserDefaultsStringForKeyReturningTime_shouldReturnTime() {
        // Given
        userDefaultsMock.stringForKeyReturnValue = "time"
        sut = Settings(userDefaults: userDefaultsMock)
        
        // When
        let audioTrigger = sut.audioTrigger
        
        // Then
        XCTAssertEqual(audioTrigger, .time)
    }
    
    func testGetAudioTrigger_withUserDefaultsStringForKeyReturningStringDistance_shouldReturnDistance() {
        // Given
        userDefaultsMock.stringForKeyReturnValue = "distance"
        sut = Settings(userDefaults: userDefaultsMock)
        
        // When
        let audioTrigger = sut.audioTrigger
        
        // Then
        XCTAssertEqual(audioTrigger, .distance)
    }
    
    func testGetAudioTrigger_withUserDefaultsStringForKeyReturningNil_shouldReturnDistance() {
        // When
        let audioTrigger = sut.audioTrigger
        
        // Then
        XCTAssertEqual(audioTrigger, .distance)
    }
    
    func testGetAudioTrigger_withUserDefaultsStringForKeyReturningStringThatIsNotDistanceOrTime_shouldReturnDistance() {
        // Given
        userDefaultsMock.stringForKeyReturnValue = "randomString"
        sut = Settings(userDefaults: userDefaultsMock)
        
        // When
        let audioTrigger = sut.audioTrigger
        
        // Then
        XCTAssertEqual(audioTrigger, .distance)
    }
    
    func testSetAudioTrigger_shouldInvokeSetOnUserDefaultsWithKeyAudioTrigger() {
        // When
        sut.audioTrigger = .time
        
        // Then
        XCTAssertEqual(userDefaultsMock.setInvokeCount, 1)
        XCTAssertEqual(userDefaultsMock.setKeyArgument, Settings.UserDefaultKey.audioTrigger.rawValue)
    }
    
    func testSetAudioTrigger_toTime_shouldInvokeSetOnUserDefaultsWithValueStringTime() {
        // When
        sut.audioTrigger = .time
        
        // Then
        XCTAssertEqual(userDefaultsMock.setValueArgument as? String, "time")
    }
    
    func testSetAudioTrigger_toDistance_shouldInvokeSetOnUserDefaultsWithValueStringDistance() {
        // When
        sut.audioTrigger = .distance
        
        // Then
        XCTAssertEqual(userDefaultsMock.setValueArgument as? String, "distance")
    }
    
    // MARK: shouldGiveTimeAudioFeedback
    
    func testGetShouldGiveTimeAudioFeedback_shouldInvokeObjectForKeyWithShouldGiveTimeAudioFeedbackKeyOnUserDefaults() {
        // When
        let _ = sut.shouldGiveTimeAudioFeedback
        
        // Then
        XCTAssertEqual(userDefaultsMock.objectForKeyInvokeCount, 1)
        XCTAssertEqual(userDefaultsMock.objectForKeyArgument, Settings.UserDefaultKey.shouldGiveTimeAudioFeedback.rawValue)
    }
    
    func testGetShouldGiveTimeAudioFeedback_withUserDefaultsObjectForKeyReturningTrue_shouldReturnTrue() {
        // Given
        userDefaultsMock.objectForKeyReturnValue = true
        sut = Settings(userDefaults: userDefaultsMock)
        
        // When
        let audioFeedbackTime = sut.shouldGiveTimeAudioFeedback
        
        // Then
        XCTAssertTrue(audioFeedbackTime)
    }
    
    func testGetShouldGiveTimeAudioFeedback_withUserDefaultsObjectForKeyReturningFalse_shouldReturnFalse() {
        // Given
        userDefaultsMock.objectForKeyReturnValue = false
        sut = Settings(userDefaults: userDefaultsMock)
        
        // When
        let audioFeedbackTime = sut.shouldGiveTimeAudioFeedback
        
        // Then
        XCTAssertFalse(audioFeedbackTime)
    }
    
    func testGetShouldGiveTimeAudioFeedback_withUserDefaultsObjectForKeyReturningNil_shouldReturnTrue() {
        // When
        let audioFeedbackTime = sut.shouldGiveTimeAudioFeedback
        
        // Then
        XCTAssertTrue(audioFeedbackTime)
    }
    
    func testSetShouldGiveTimeAudioFeedback_shouldInvokeSetOnUserDefaultsWithKeyhouldGiveTimeAudioFeedback() {
        // When
        sut.shouldGiveTimeAudioFeedback = true
        
        // Then
        XCTAssertEqual(userDefaultsMock.setInvokeCount, 1)
        XCTAssertEqual(userDefaultsMock.setKeyArgument, Settings.UserDefaultKey.shouldGiveTimeAudioFeedback.rawValue)
    }
    
    func testSetShouldGiveTimeAudioFeedback_toTrue_shouldInvokeSetOnUserDefaultsWithValueTrue() {
        // When
        sut.shouldGiveTimeAudioFeedback = true
        
        // Then
        XCTAssertEqual(userDefaultsMock.setValueArgument as? Bool, true)
    }
    
    func testSetShouldGiveTimeAudioFeedback_toFalse_shouldInvokeSetOnUserDefaultsWithValueFalse() {
        // When
        sut.shouldGiveTimeAudioFeedback = false
        
        // Then
        XCTAssertEqual(userDefaultsMock.setValueArgument as? Bool, false)
    }
    
    
    // MARK: shouldGiveDistanceAudioFeedback
    
    func testGetShouldGiveDistanceAudioFeedback_shouldInvokeObjectForKeyWithShouldGiveDistanceAudioFeedbackKeyOnUserDefaults() {
        // When
        let _ = sut.shouldGiveDistanceAudioFeedback
        
        // Then
        XCTAssertEqual(userDefaultsMock.objectForKeyInvokeCount, 1)
        XCTAssertEqual(userDefaultsMock.objectForKeyArgument, Settings.UserDefaultKey.shouldGiveDistanceAudioFeedback.rawValue)
    }
    
    func testGetShouldGiveTimeDistanceFeedback_withUserDefaultsObjectForKeyReturningTrue_shouldReturnTrue() {
        // Given
        userDefaultsMock.objectForKeyReturnValue = true
        sut = Settings(userDefaults: userDefaultsMock)
        
        // When
        let audioFeedbackDistance = sut.shouldGiveDistanceAudioFeedback
        
        // Then
        XCTAssertTrue(audioFeedbackDistance)
    }
    
    func testGetShouldGiveDistanceAudioFeedback_withUserDefaultsObjectForKeyReturningFalse_shouldReturnFalse() {
        // Given
        userDefaultsMock.objectForKeyReturnValue = false
        sut = Settings(userDefaults: userDefaultsMock)
        
        // When
        let audioFeedbackDistance = sut.shouldGiveDistanceAudioFeedback
        
        // Then
        XCTAssertFalse(audioFeedbackDistance)
    }
    
    func testGetShouldGiveDistanceAudioFeedback_withUserDefaultsObjectForKeyReturningNil_shouldReturnTrue() {
        // When
        let audioFeedbackDistance = sut.shouldGiveDistanceAudioFeedback
        
        // Then
        XCTAssertTrue(audioFeedbackDistance)
    }
    
    func testSetShouldGiveDistanceAudioFeedback_shouldInvokeSetOnUserDefaultsWithKeyhouldGiveDistanceAudioFeedback() {
        // When
        sut.shouldGiveDistanceAudioFeedback = true
        
        // Then
        XCTAssertEqual(userDefaultsMock.setInvokeCount, 1)
        XCTAssertEqual(userDefaultsMock.setKeyArgument, Settings.UserDefaultKey.shouldGiveDistanceAudioFeedback.rawValue)
    }
    
    func testSetShouldGiveDistanceAudioFeedback_toTrue_shouldInvokeSetOnUserDefaultsWithValueTrue() {
        // When
        sut.shouldGiveDistanceAudioFeedback = true
        
        // Then
        XCTAssertEqual(userDefaultsMock.setValueArgument as? Bool, true)
    }
    
    func testSetShouldGiveDistanceAudioFeedback_toFalse_shouldInvokeSetOnUserDefaultsWithValueFalse() {
        // When
        sut.shouldGiveDistanceAudioFeedback = false
        
        // Then
        XCTAssertEqual(userDefaultsMock.setValueArgument as? Bool, false)
    }
    
    // MARK: shouldGiveAveragePaceAudioFeedback
    
    func testGetShouldGiveAveragePaceAudioFeedback_shouldInvokeObjectForKeyWithShouldGiveAveragePaceAudioFeedbackKeyOnUserDefaults() {
        // When
        let _ = sut.shouldGiveAveragePaceAudioFeedback
        
        // Then
        XCTAssertEqual(userDefaultsMock.objectForKeyInvokeCount, 1)
        XCTAssertEqual(userDefaultsMock.objectForKeyArgument, Settings.UserDefaultKey.shouldGiveAveragePaceAudioFeedback.rawValue)
    }
    
    func testGetShouldGiveAveragePaceDistanceFeedback_withUserDefaultsObjectForKeyReturningTrue_shouldReturnTrue() {
        // Given
        userDefaultsMock.objectForKeyReturnValue = true
        sut = Settings(userDefaults: userDefaultsMock)
        
        // When
        let audioFeedbackAveragePace = sut.shouldGiveAveragePaceAudioFeedback
        
        // Then
        XCTAssertTrue(audioFeedbackAveragePace)
    }
    
    func testGetShouldGiveAveragePaceAudioFeedback_withUserDefaultsObjectForKeyReturningFalse_shouldReturnFalse() {
        // Given
        userDefaultsMock.objectForKeyReturnValue = false
        sut = Settings(userDefaults: userDefaultsMock)
        
        // When
        let audioFeedbackAveragePace = sut.shouldGiveAveragePaceAudioFeedback
        
        // Then
        XCTAssertFalse(audioFeedbackAveragePace)
    }
    
    func testGetShouldGiveAveragePaceAudioFeedback_withUserDefaultsObjectForKeyReturningNil_shouldReturnTrue() {
        // When
        let audioFeedbackAveragePace = sut.shouldGiveAveragePaceAudioFeedback
        
        // Then
        XCTAssertTrue(audioFeedbackAveragePace)
    }
    
    func testSetShouldGiveAveragePaceAudioFeedback_shouldInvokeSetOnUserDefaultsWithKeyhouldGiveAveragePaceAudioFeedback() {
        // When
        sut.shouldGiveAveragePaceAudioFeedback = true
        
        // Then
        XCTAssertEqual(userDefaultsMock.setInvokeCount, 1)
        XCTAssertEqual(userDefaultsMock.setKeyArgument, Settings.UserDefaultKey.shouldGiveAveragePaceAudioFeedback.rawValue)
    }
    
    func testSetShouldGiveAveragePaceAudioFeedback_toTrue_shouldInvokeSetOnUserDefaultsWithValueTrue() {
        // When
        sut.shouldGiveAveragePaceAudioFeedback = true
        
        // Then
        XCTAssertEqual(userDefaultsMock.setValueArgument as? Bool, true)
    }
    
    func testSetShouldGiveAveragePaceAudioFeedback_toFalse_shouldInvokeSetOnUserDefaultsWithValueFalse() {
        // When
        sut.shouldGiveAveragePaceAudioFeedback = false
        
        // Then
        XCTAssertEqual(userDefaultsMock.setValueArgument as? Bool, false)
    }
    
    
    // MARK: audioTimingInterval
    
    
    
    // MARK: runRatingRange
    
    func testRunRatingRangeHasLowerBoundZeroPointOneAndUpperBoundOne() {
        XCTAssertEqual(0.01, sut.runRatingRange.lowerBound)
        XCTAssertEqual(1, sut.runRatingRange.upperBound)
    }

    
    
}

class UserDefaultsMock: UserDefaults {
    
    var stringForKeyInvokeCount: Int = 0
    var stringForKeyArgument: String?
    var stringForKeyReturnValue: String?
    
    var objectForKeyInvokeCount: Int = 0
    var objectForKeyArgument: String?
    var objectForKeyReturnValue: Any?
    
    var setInvokeCount: Int = 0
    var setValueArgument: Any?
    var setKeyArgument: String?
    
    override func string(forKey defaultName: String) -> String? {
        stringForKeyInvokeCount += 1
        stringForKeyArgument = defaultName
        return stringForKeyReturnValue
    }
    
    override func object(forKey defaultName: String) -> Any? {
        objectForKeyInvokeCount += 1
        objectForKeyArgument = defaultName
        return objectForKeyReturnValue
    }
    
    override func set(_ value: Any?, forKey defaultName: String) {
        setInvokeCount += 1
        setValueArgument = value
        setKeyArgument = defaultName
    }
    
}
