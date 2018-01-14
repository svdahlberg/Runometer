//
//  AudioFeedback.swift
//  Runometer
//
//  Created by Svante Dahlberg on 2018-01-13.
//  Copyright © 2018 Svante Dahlberg. All rights reserved.
//

import Foundation

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
    
    private let appConfiguration: AppConfiguration
    private let run: Run
    
    init(appConfiguration: AppConfiguration = AppConfiguration(), run: Run) {
        self.appConfiguration = appConfiguration
        self.run = run
    }
    
    func speak() {
        
    }
    
    var text: String? {
        let texts = audioFeedbackTypes.flatMap { $0.text }
        return texts.reduce("", { $0 == "" ? $1 : $0 + ", " + $1 })
    }
    
    private var audioFeedbackTypes: [AudioFeedbackType] {
        let formattedTime = TimeFormatter.format(time: Seconds(run.duration), unitStyle: .full, zeroFormattingBehavior: .dropAll)
        let formattedDistance = DistanceFormatter.formatWithLongUnitName(distance: run.distance)
        let formattedPace = PaceFormatter.formatUsingLongUnitName(pace: run.averagePace())
        
        let time: AudioFeedbackType? = appConfiguration.shouldGiveTimeAudioFeedback ? .time(formattedTime) : nil
        let distance: AudioFeedbackType? = appConfiguration.shouldGiveDistanceAudioFeedback ? .distance(formattedDistance) : nil
        let pace: AudioFeedbackType? = appConfiguration.shouldGiveAveragePaceAudioFeedback ? .pace(formattedPace) : nil
    
        return [time, distance, pace].flatMap { $0 }
    }
    
}
