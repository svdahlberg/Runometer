//
//  AppConfiguration.swift
//  Runometer
//
//  Created by Svante Dahlberg on 2017-11-19.
//  Copyright © 2017 Svante Dahlberg. All rights reserved.
//

import Foundation

struct AppConfiguration {
    let settings: SettingsProvider
    
    init(settings: SettingsProvider = Settings.shared) {
        self.settings = settings
    }
    
    // MARK: Units
    var distanceUnit: DistanceUnit {
        return settings.distanceUnit ?? .kilometers
    }
    
    var speedUnit: SpeedUnit {
        switch distanceUnit {
        case .kilometers: return .minutesPerKilometer
        case .miles: return .minutesPerMile
        }
    }
    
    // MARK: Audio Feedback
    var audioTrigger: AudioTrigger {
        return settings.audioTrigger ?? .distance
    }
    
    var shouldGiveDistanceAudioFeedback: Bool {
        return settings.audioFeedbackDistance ?? true
    }
    
    var shouldGiveTimeAudioFeedback: Bool {
        return settings.audioFeedbackTime ?? true
    }
    
    var shouldGiveAveragePaceAudioFeedback: Bool {
        return settings.audioFeedbackAveragePace ?? true
    }
    
    var shouldGiveSplitPaceAudioFeedback: Bool {
        return settings.audioFeedbackSplitPace ?? false
    }
    
    var audioTimingInterval: Double {
        let defaultValue = audioTrigger == .time ? 5.0 : 1.0
        return settings.audioTimingInterval ?? defaultValue
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
}
