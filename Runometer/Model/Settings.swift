//
//  Settings.swift
//  Runometer
//
//  Created by Svante Dahlberg on 2017-11-18.
//  Copyright © 2017 Svante Dahlberg. All rights reserved.
//

import Foundation
import CoreGraphics

class Settings {
    
    enum UserDefaultKey: String {
        case distanceUnit = "distanceUnit"
        case shouldGiveDistanceAudioFeedback = "shouldGiveDistanceAudioFeedback"
        case shouldGiveTimeAudioFeedback = "shouldGiveTimeAudioFeedback"
        case shouldGiveAveragePaceAudioFeedback = "shouldGiveAveragePaceAudioFeedback"
        case audioTrigger = "audioTrigger"
        case audioTimingInterval = "audioTimingInterval"
    }
    
    private let userDefaults: UserDefaults
    
    init(userDefaults: UserDefaults = UserDefaults.standard) {
        self.userDefaults = userDefaults
    }
    
    // MARK: Units
    
    var distanceUnit: DistanceUnit {
        get {
            guard let savedDistanceUnitSymbol = userDefaults.string(forKey: UserDefaultKey.distanceUnit.rawValue) else {
                return .kilometers
            }
            return DistanceUnit.parse(distanceUnitSymbol: savedDistanceUnitSymbol) ?? .kilometers
        }
        set { userDefaults.set(newValue.symbol, forKey: UserDefaultKey.distanceUnit.rawValue) }
    }
    
    var speedUnit: SpeedUnit {
        switch distanceUnit {
        case .kilometers: return .minutesPerKilometer
        case .miles: return .minutesPerMile
        }
    }
    
    // MARK: Audio Feedback
    
    var audioTrigger: AudioTrigger {
        get {
            guard let savedAudioTrigger = userDefaults.string(forKey: UserDefaultKey.audioTrigger.rawValue) else {
                return .distance
            }
            return AudioTrigger.parse(string: savedAudioTrigger)  ?? .distance
        }
        set { userDefaults.set(newValue.rawValue, forKey: UserDefaultKey.audioTrigger.rawValue) }
    }
    
    var shouldGiveTimeAudioFeedback: Bool {
        get { return userDefaults.object(forKey: UserDefaultKey.shouldGiveTimeAudioFeedback.rawValue) as? Bool ?? true }
        set { userDefaults.set(newValue, forKey: UserDefaultKey.shouldGiveTimeAudioFeedback.rawValue) }
    }
    
    var shouldGiveDistanceAudioFeedback: Bool {
        get { return userDefaults.object(forKey: UserDefaultKey.shouldGiveDistanceAudioFeedback.rawValue) as? Bool ?? true }
        set { userDefaults.set(newValue, forKey: UserDefaultKey.shouldGiveDistanceAudioFeedback.rawValue) }
    }
    
    var shouldGiveAveragePaceAudioFeedback: Bool {
        get { return userDefaults.object(forKey: UserDefaultKey.shouldGiveAveragePaceAudioFeedback.rawValue) as? Bool ?? true }
        set { userDefaults.set(newValue, forKey: UserDefaultKey.shouldGiveAveragePaceAudioFeedback.rawValue) }
    }
    
    var audioTimingInterval: Double {
        get { return userDefaults.object(forKey: UserDefaultKey.audioTimingInterval.rawValue) as? Double ?? defaultAudioTimingIntervalValue() }
        set { userDefaults.set(newValue, forKey: UserDefaultKey.audioTimingInterval.rawValue) }
    }
    
    private func defaultAudioTimingIntervalValue() -> Double {
        return audioTrigger == .time ? 5.0 : 1.0
    }
    
    func resetAudioTimingInterval() {
        userDefaults.set(nil, forKey: UserDefaultKey.audioTimingInterval.rawValue)
    }
    
    let timeIntervals: [Double] = [1, 5, 10, 15]
    let kilometerIntervals: [Double] = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
    let mileIntervals: [Double] = [0.5, 1, 1.5, 2, 2.5, 3]
    
    var audioIntervals: [Double] {
        switch audioTrigger {
        case .distance:
            return distanceUnit == .kilometers ? kilometerIntervals : mileIntervals
        case .time:
            return timeIntervals
        }
    }
    
    // MARK: Run Rating
    
    var runRatingRange: ClosedRange<CGFloat> = 0.01...1

}
