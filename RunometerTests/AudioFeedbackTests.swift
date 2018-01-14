//
//  AudioFeedbackTests.swift
//  RunometerTests
//
//  Created by Svante Dahlberg on 2018-01-13.
//  Copyright © 2018 Svante Dahlberg. All rights reserved.
//

import XCTest
@testable import Runometer
import CoreData

class AudioFeedbackTests: XCTestCase {
    
    private func audioFeedback(context: NSManagedObjectContext) -> AudioFeedback {
        let appConfigurationMock = AppConfigurationMock()
        
        let runMock = Run.runMock(context: context)
        return AudioFeedback(appConfiguration: appConfigurationMock, run: runMock)
    }
    
    func testText_withThreeAudioFeedbackTypes_ReturnsCorrectlyFormattedTextToSpeak() {
        let context = CoreDataHelper.inMemoryManagedObjectContext()!
        let sut = audioFeedback(context: context)
        XCTAssertEqual("Time: 25 minutes, Distance: 5 kilometers, Average pace: 5 minutes per kilometer", sut.text)
    }
    
}
