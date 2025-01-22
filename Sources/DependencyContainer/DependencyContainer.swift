import Foundation
//
//MARK: - Dependency Container Using Lock DispatchQueue Barrier
/*
 public typealias DC = DependencyContainer

 public final class DependencyContainer: @unchecked Sendable {

     //MARK: - Shared Instance
     public static let shared = DependencyContainer()

     //MARK: - Single Instance Dependency
     private var singleInstanceDependencies: [ObjectIdentifier: AnyObject] = [:]

     //MARK: - Closure Based Dependency & Any because of we don't know the type maybe be struct || enum || etc
     private var closureBasedDependencies: [ObjectIdentifier: () -> Any] = [:]



     private let dependencyAccessQueue = DispatchQueue(
         label: "com.modularisation.dependency.container.access.queue",
         attributes: .concurrent
     )


     private init() {}

     //MARK: - Registration Dependency based on type (single, closure)
     public func register(type: DependencyContainerRegistrationType,
                          for interface: Any.Type /* for ObjectIdentifier */) {
         dependencyAccessQueue.sync(flags: .barrier) {
             let objectIdentifier = ObjectIdentifier(interface)
             switch type {
                 case .singleInstance(let instance):
                     singleInstanceDependencies[objectIdentifier] = instance
                 case .closureBased(let closure):
                     closureBasedDependencies[objectIdentifier] = closure
             }
         }
     }

     //MARK: - Resolving Method
     public func resolve<Value>(type: DependencyContainerResolvingType, for interface: Value.Type) -> Value {
         var value: Value!
         dependencyAccessQueue.sync {
             let objectIdentifier = ObjectIdentifier(interface)
             switch type {
                 case .singleInstance:
                     guard let singleInstanceDependency = singleInstanceDependencies[objectIdentifier] as? Value else {
                         fatalError("Could not retrieve a dependency for the given type: \(interface)")
                     }
                     value = singleInstanceDependency

                 case .closureBased:
                     guard let closure = closureBasedDependencies[objectIdentifier],
                           let closureBasedDependency = closure() as? Value else {
                         fatalError("Could not retrieve closure based dependency for the given type: \(interface)")
                     }
                     value = closureBasedDependency
             }
         }
         return value
     }
 }
 */
