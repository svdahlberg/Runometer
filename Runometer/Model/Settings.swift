//
//  Settings.swift
//  Runometer
//
//  Created by Svante Dahlberg on 2017-11-18.
//  Copyright © 2017 Svante Dahlberg. All rights reserved.
//

import Foundation

protocol SettingsProvider {
    var distanceUnit: DistanceUnit? { get set }
    var audioFeedbackDistance: Bool? { get set }
    var audioFeedbackTime: Bool? { get set }
    var audioFeedbackAveragePace: Bool? { get set }
    var audioTrigger: AudioTrigger? { get set }
    var audioTimingInterval: Double? { get set }
}

struct Settings: SettingsProvider {
    static var shared = Settings()
    private init() {}
    
    private enum UserDefaultKey: String {
        case distanceUnit = "distanceUnit"
        case audioFeedbackDistance = "audioFeedbackDistance"
        case audioFeedbackTime = "audioFeedbackTime"
        case audioFeedbackAveragePace = "audioFeedbackAveragePace"
        case audioTrigger = "audioTrigger"
        case audioTimingInterval = "audioTimingInterval"
    }
    
    private var userDefaults = UserDefaults.standard
    
    var distanceUnit: DistanceUnit? {
        get {
            guard let savedDistanceUnitSymbol = userDefaults.string(forKey: UserDefaultKey.distanceUnit.rawValue) else {
                return nil
            }
            return DistanceUnit.parse(distanceUnitSymbol: savedDistanceUnitSymbol)
        }
        set { userDefaults.set(newValue?.symbol, forKey: UserDefaultKey.distanceUnit.rawValue) }
    }
    
    var audioFeedbackDistance: Bool? {
        get { return userDefaults.object(forKey: UserDefaultKey.audioFeedbackDistance.rawValue) as? Bool }
        set { userDefaults.set(newValue, forKey: UserDefaultKey.audioFeedbackDistance.rawValue) }
    }

    var audioFeedbackTime: Bool? {
        get { return userDefaults.object(forKey: UserDefaultKey.audioFeedbackTime.rawValue) as? Bool }
        set { userDefaults.set(newValue, forKey: UserDefaultKey.audioFeedbackTime.rawValue) }
    }
    
    var audioFeedbackAveragePace: Bool? {
        get { return userDefaults.object(forKey: UserDefaultKey.audioFeedbackAveragePace.rawValue) as? Bool }
        set { userDefaults.set(newValue, forKey: UserDefaultKey.audioFeedbackAveragePace.rawValue) }
    }
    
    var audioTrigger: AudioTrigger? {
        get {
            guard let savedAudioTrigger = userDefaults.string(forKey: UserDefaultKey.audioTrigger.rawValue) else {
                return nil
            }
            return AudioTrigger.parse(string: savedAudioTrigger)
        }
        set { userDefaults.set(newValue?.rawValue, forKey: UserDefaultKey.audioTrigger.rawValue) }
    }
    
    var audioTimingInterval: Double? {
        get { return userDefaults.object(forKey: UserDefaultKey.audioTimingInterval.rawValue) as? Double }
        set { userDefaults.set(newValue, forKey: UserDefaultKey.audioTimingInterval.rawValue) }
    }

}
