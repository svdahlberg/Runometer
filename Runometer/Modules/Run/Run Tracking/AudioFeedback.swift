//
//  AudioFeedback.swift
//  Runometer
//
//  Created by Svante Dahlberg on 2018-01-13.
//  Copyright © 2018 Svante Dahlberg. All rights reserved.
//

import Foundation
import AVFoundation

enum AudioFeedbackType {
    case distance(String?), time(String?), pace(String?)
    
    var text: String? {
        switch self {
        case .distance(let distance):
            guard let distance = distance else { return nil }
            return "Distance: \(distance)"
        case .time(let time):
            guard let time = time else { return nil }
            return "Time: \(time)"
        case .pace(let pace):
            guard let pace = pace else { return nil }
            return "Average pace: \(pace)"
        }
    }
}

struct AudioFeedback {
    
    private let settings: Settings
    private let distance: Meters
    private let time: Seconds
    private let speechSynthesizer: AVSpeechSynthesizer
    
    init(settings: Settings = Settings(), distance: Meters, time: Seconds) {
        self.settings = settings
        self.distance = distance
        self.time = time
        self.speechSynthesizer = AVSpeechSynthesizer()
    }
    
    func speak() {
        guard let text = text else { return }
        let utterance = AVSpeechUtterance(string: text)
        speechSynthesizer.speak(utterance)
    }
    
    var text: String? {
        let texts = audioFeedbackTypes.compactMap { $0.text }
        return texts.reduce("", { $0 == "" ? $1 : $0 + ", " + $1 })
    }
    
    private var audioFeedbackTypes: [AudioFeedbackType] {
        let formattedTime = TimeFormatter.format(time: time, unitStyle: .full, zeroFormattingBehavior: .dropAll)
        let formattedDistance = DistanceFormatter.formatWithLongUnitName(distance: distance)
        let pace = PaceCalculator.pace(fromDistance: distance, time: time, outputUnit: settings.speedUnit)
        let formattedPace = PaceFormatter.formatUsingLongUnitName(pace: pace)
        
        let timeFeedback: AudioFeedbackType? = settings.shouldGiveTimeAudioFeedback ? .time(formattedTime) : nil
        let distanceFeedback: AudioFeedbackType? = settings.shouldGiveDistanceAudioFeedback ? .distance(formattedDistance) : nil
        let paceFeedback: AudioFeedbackType? = settings.shouldGiveAveragePaceAudioFeedback ? .pace(formattedPace) : nil
    
        return [timeFeedback, distanceFeedback, paceFeedback].compactMap { $0 }
    }
    
}
