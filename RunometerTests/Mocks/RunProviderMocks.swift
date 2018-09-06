//
//  RunProviderMocks.swift
//  RunometerTests
//
//  Created by Svante Dahlberg on 2017-12-26.
//  Copyright © 2017 Svante Dahlberg. All rights reserved.
//

import Foundation
@testable import Runometer

class RunProviderMock: RunProvider {
    override func savedRuns() -> [ManagedRunObject]? {
        return ManagedRunObject.runsMock(context: context)
    }
}

class RunProviderMockWithLongestRunOneKilometerLongerThanNextLongestRun: RunProvider {
    override func savedRuns() -> [ManagedRunObject]? {
        return Array(ManagedRunObject.runsMock(context: context).dropLast())
    }
}

class RunProviderMockWithLongestRunOneMeterLongerThanNextLongestRun: RunProvider {
    override func savedRuns() -> [ManagedRunObject]? {
        var runs = Array(ManagedRunObject.runsMock(context: context))
        runs.append(ManagedRunObject(context: context, distance: 10001, time: 3600, locationSegments: [], date: Date(timeIntervalSince1970: 0)))
        return runs
    }
}

class RunProviderMockWithShortestRunOneMeterShorterThanNextShortestRun: RunProvider {
    override func savedRuns() -> [ManagedRunObject]? {
        var runs = Array(ManagedRunObject.runsMock(context: context))
        runs.append(ManagedRunObject(context: context, distance: 999, time: 360, locationSegments: [], date: Date(timeIntervalSince1970: 0)))
        return runs
    }
}

class RunProviderMockWithOneSavedRun: RunProvider {
    override func savedRuns() -> [ManagedRunObject]? {
        return [ManagedRunObject.runsMock(context: context).first!]
    }
}
