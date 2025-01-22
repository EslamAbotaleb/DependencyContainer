//
//  File.swift
//  DependencyContainer
//
//  Created by Eslam on 12/01/2025.
//

import Foundation

protocol ClosureBasedProtocol: Sendable {
    func sampleMethod()
}

struct ClosureBasedImplemenation: ClosureBasedProtocol {
    func sampleMethod() {
    }
}

//MARK: - Dependency depend on another dependency
protocol AnotherDependencyProtocol: Sendable {
    func anotherSampleMethod()
}

struct AnotherDependencyImplementation: AnotherDependencyProtocol {

    //MARK: - dependency injection protocol instead of deal direct with implementation

    private let service: ClosureBasedProtocol
    init(service: ClosureBasedProtocol) {
        self.service = service
    }

    func anotherSampleMethod() {

    }
}
