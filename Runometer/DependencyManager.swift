//
//  DependencyManager.swift
//  Runometer
//
//  Created by Svante Dahlberg on 4/10/21.
//  Copyright © 2021 Svante Dahlberg. All rights reserved.
//

import Foundation

class DependencyManager {

    static let shared = DependencyManager(container: DependencyContainer())

    var container: DependencyContainer

    private init(container: DependencyContainer) {
        self.container = container
    }

    func registerDependencies() {

        container.register(RunProviding.self, resolver: { RunProvider() })
    }
}
