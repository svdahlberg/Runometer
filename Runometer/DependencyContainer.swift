//
//  DependencyContainer.swift
//  Runometer
//
//  Created by Svante Dahlberg on 4/10/21.
//  Copyright © 2021 Svante Dahlberg. All rights reserved.
//

import Foundation

class DependencyContainer {

    typealias Dependency = Any
    typealias Resolver = () -> Dependency
    typealias Identifier = String

    private var dependencies: [Identifier: Resolver]

    init() {
        dependencies = [:]
    }

    func register<Dependency>(_ dependency: Dependency.Type, resolver: @escaping Resolver) {
        dependencies[resolverIdentifier(for: dependency)] = resolver
    }

    func resolve<Dependency>(_ dependency: Dependency.Type) -> Dependency? {
        let resolver = dependencies[resolverIdentifier(for: dependency)]
        return resolver?() as? Dependency
    }

    private func resolverIdentifier<Dependency>(for dependency: Dependency.Type) -> Identifier {
        String(describing: dependency)
    }

}
