//
//  DependencyContainer2.swift
//  DependencyContainer
//
//  Created by Eslam on 13/01/2025.
//

import Foundation

public typealias DCSafe = DependencyContainerSafe


public actor DependencyContainerSafe {

    //MARK: - Shared Instance
    public static let shared = DependencyContainerSafe()

    //MARK: - Single Instance Dependency
    private var singleInstanceDependencies: [ObjectIdentifier: Sendable] = [:]

    //MARK: - Closure Based Dependency & Any because of we don't know the type maybe be struct || enum || etc
    //Any
    //ObjectIdentifier allow us to register our types our protocols
    private var closureBasedDependencies: [ObjectIdentifier: () async -> Sendable] = [:]

    // Internal initial for only inside the package
    init() {}

    //MARK: - Registration Dependency based on type (single, closure)
    public func register(type: DependencyContainerRegistrationType,
                         for interface: Any.Type /* for ObjectIdentifier */) {
        let objectIdentifier = ObjectIdentifier(interface)
        switch type {
            case .singleInstance(let instance):
                singleInstanceDependencies[objectIdentifier] = instance
            case .closureBased(let closure):
                closureBasedDependencies[objectIdentifier] = closure
        }
    }
    //MARK: - Resolving Method
    public func resolve<Value>(type: DependencyContainerResolvingType, for interface: Value.Type) async -> Value {
        var value: Value!
        let objectIdentifier = ObjectIdentifier(interface)
        switch type {
            case .singleInstance:
                guard let singleInstanceDependency = singleInstanceDependencies[objectIdentifier] as? Value else {
                    fatalError("Could not retrieve a dependency for the given type: \(interface)")
                }
                value = singleInstanceDependency
            case .closureBased:
                guard let closure =  closureBasedDependencies[objectIdentifier],
                      let closureBasedDependency =  await closure() as? Value else {
                    fatalError("Could not retrieve closure based dependency for the given type: \(interface)")

                }
                value = closureBasedDependency
        }
        return value
    }
}
