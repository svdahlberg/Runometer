//
//  AudioTrigger.swift
//  Runometer
//
//  Created by Svante Dahlberg on 2017-11-18.
//  Copyright © 2017 Svante Dahlberg. All rights reserved.
//

import Foundation

enum AudioTrigger: String {
    case time = "time"
    case distance = "distance"
    
    static func parse(string: String) -> AudioTrigger? {
        switch string {
        case "time": return .time
        case "distance": return .distance
        default: return nil
        }
    }
}
