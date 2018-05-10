//
//  AudioFeedbackController.swift
//  Runometer
//
//  Created by Svante Dahlberg on 2018-01-21.
//  Copyright © 2018 Svante Dahlberg. All rights reserved.
//

import Foundation

struct AudioFeedbackController {
    
    private let settings: Settings

    private(set) var valueAtLastAudioFeedback: Double
    
    private(set) lazy var valueAtNextAudioFeedback: Double = audioFeedbackInterval
    
    var distance: Meters {
        didSet {
            guard trigger == .distance else { return }
            
            if distance >= valueAtNextAudioFeedback {
                speak()
            }
        }
    }
    
    var time: Seconds {
        didSet {
            guard trigger == .time else { return }
            
            if time >= Int(valueAtNextAudioFeedback) {
                speak()
            }
        }
    }
    
    init(settings: Settings = Settings()) {
        self.settings = settings
        distance = 0
        time = 0
        valueAtLastAudioFeedback = 0
    }
    
    private var trigger: AudioTrigger {
        return settings.audioTrigger
    }
    
    private var audioFeedbackInterval: Double {
        switch trigger {
        case .time:
            return settings.audioTimingInterval * 60
        case .distance:
            return settings.audioTimingInterval * settings.distanceUnit.meters
        }
    }
    
    private mutating func speak() {
        AudioFeedback(distance: distance, time: time).speak()
        valueAtLastAudioFeedback = valueAtNextAudioFeedback
        valueAtNextAudioFeedback += audioFeedbackInterval
    }
    
}
