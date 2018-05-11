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
    override func savedRuns() -> [Run]? {
        return Run.runsMock(context: context)
    }
}

class RunProviderMockWithLongestRunOneKilometerLongerThanNextLongestRun: RunProvider {
    override func savedRuns() -> [Run]? {
        return Array(Run.runsMock(context: context).dropLast())
    }
}

class RunProviderMockWithLongestRunOneMeterLongerThanNextLongestRun: RunProvider {
    override func savedRuns() -> [Run]? {
        var runs = Array(Run.runsMock(context: context))
        runs.append(Run(context: context, distance: 10001, time: 3600, locationSegments: [], date: Date(timeIntervalSince1970: 0)))
        return runs
    }
}

class RunProviderMockWithShortestRunOneMeterShorterThanNextShortestRun: RunProvider {
    override func savedRuns() -> [Run]? {
        var runs = Array(Run.runsMock(context: context))
        runs.append(Run(context: context, distance: 999, time: 360, locationSegments: [], date: Date(timeIntervalSince1970: 0)))
        return runs
    }
}

class RunProviderMockWithOneSavedRun: RunProvider {
    override func savedRuns() -> [Run]? {
        return [Run.runsMock(context: context).first!]
    }
}
