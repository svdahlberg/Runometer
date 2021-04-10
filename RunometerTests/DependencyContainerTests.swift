//
//  DependencyContainerTests.swift
//  RunometerTests
//
//  Created by Svante Dahlberg on 4/10/21.
//  Copyright © 2021 Svante Dahlberg. All rights reserved.
//

import XCTest
@testable import Runometer

class DependencyContainerTests: XCTestCase {

    var sut: DependencyContainer!

    override func setUpWithError() throws {
        sut = DependencyContainer()
        super.setUp()
    }

    func testResolve_withRegisteredDependency_shouldInvokeResolver() {
        // Given
        sut.register(MockDependency.self) { MockDependency() }

        // When
        let mockDependency = sut.resolve(MockDependency.self)

        // Then
        XCTAssertEqual(mockDependency?.initInvokeCount, 1)
    }

    func testResolve_withNonRegisteredDependency_shouldReturnNil() {
        // Given

        // When
        let mockDependency = sut.resolve(MockDependency.self)

        // Then
        XCTAssertNil(mockDependency)
    }

}

struct MockDependency {

    var initInvokeCount = 0

    init() {
        initInvokeCount += 1
    }

}
