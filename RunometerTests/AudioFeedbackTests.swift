//
//  AudioFeedbackTests.swift
//  RunometerTests
//
//  Created by Svante Dahlberg on 2018-01-13.
//  Copyright © 2018 Svante Dahlberg. All rights reserved.
//

import XCTest
@testable import Runometer

class AudioFeedbackTests: XCTestCase {
    
    func testText_withThreeAudioFeedbackTypes_ReturnsCorrectlyFormattedText() {
        
        let audioFeedback = AudioFeedback(appConfiguration: AppConfigurationMock(), distance: 5000, time: 1500)
        
        XCTAssertEqual("Time: 25 minutes, Distance: 5 kilometers, Average pace: 5 minutes per kilometer", audioFeedback.text)
    }
    
    
}

