//
//  RunProviderMock.swift
//  RunometerTests
//
//  Created by Svante Dahlberg on 2018-09-11.
//  Copyright © 2018 Svante Dahlberg. All rights reserved.
//

import Foundation
@testable import Runometer

class RunProviderMock: RunProviding, RunObserving {

    var runsInvokeCount: Int = 0
    var runsCompletionArgument: [Run]? = RunMock.runs
    
    func runs(filter: RunFilter?, completion: @escaping ([Run]) -> Void) {
        runsInvokeCount += 1
        completion(runsCompletionArgument ?? [])
    }

    var observeInvokeCount = 0
    var observerCompletionArgument: [Run]?

    func observe(_ completion: @escaping ([Run]) -> Void) {
        observeInvokeCount += 1
        completion(observerCompletionArgument ?? [])
    }

}
