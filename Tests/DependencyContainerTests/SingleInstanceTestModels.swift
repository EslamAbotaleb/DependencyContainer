//
//  SingleInstanceTestModels.swift
//  DependencyContainer
//
//  Created by Eslam on 12/01/2025.
//

import Foundation
protocol SingleInstanceProtocol: AnyObject, Sendable {
 func sampleMethod()
}
final class SingleInstanceImplementation: SingleInstanceProtocol {
    func sampleMethod() {

    }
}
