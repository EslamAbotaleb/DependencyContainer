//
//  DependencyContainerRegistrationType.swift
//  DependencyContainer
//
//  Created by Eslam on 12/01/2025.
//

import Foundation

/*
 public enum DependencyContainerRegistrationType: @unchecked Sendable {
 //MARK: - We don't here define any optional cause of don't need to initial default value for dependency container
 case singleInstance(AnyObject)
 case closureBased(() async -> Any)
 }
*/
public enum DependencyContainerRegistrationType: Sendable {
    //MARK: - We don't here define any optional cause of don't need to initial default value for dependency container
    // cause of deal with concurrency safe use Sendable instead of AnyObject
    case singleInstance(Sendable)
    case closureBased(@Sendable () async -> Any)
}
