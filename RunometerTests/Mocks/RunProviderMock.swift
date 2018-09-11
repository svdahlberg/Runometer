//
//  RunProviderMock.swift
//  RunometerTests
//
//  Created by Svante Dahlberg on 2018-09-11.
//  Copyright © 2018 Svante Dahlberg. All rights reserved.
//

import Foundation
@testable import Runometer

class RunProviderMock: RunProviding {
    
    var runsInvokeCount: Int = 0
    var runsCompletionArgument: [Run]?
    
    func runs(completion: @escaping ([Run]) -> Void) {
        runsInvokeCount += 1
        completion(runsCompletionArgument ?? [])
    }
    
}
