import XCTest
@testable import DependencyContainer

final class DependencyContainerTests: XCTestCase {

    var sut: DependencyContainerSafe!

    override func setUp() {
        super.setUp()
        sut = .init()
    }
    override  func tearDown() {
        sut = nil
        super.tearDown()
    }
    func test_single_instance_registration_and_resolving() async {
        let instance = SingleInstanceImplementation()

        //MARK: - Register
       await sut.register(type: .singleInstance(instance), for: SingleInstanceProtocol.self)
        //MARK: - Resolved

        let resolvedInstance = await sut.resolve(type: .singleInstance, for: SingleInstanceProtocol.self)
        //MARK: - === this mean will be same object in memory not only for data type
        XCTAssert(instance === resolvedInstance)
    }
    func test_closure_based_registration_and_resolving() async {
        let closure: @Sendable () -> ClosureBasedProtocol = {
            ClosureBasedImplemenation()
        }

        await sut.register(type: .closureBased(closure), for: ClosureBasedProtocol.self)

        let resolved = await sut.resolve(type: .closureBased, for: ClosureBasedProtocol.self)
        XCTAssert(resolved is ClosureBasedImplemenation)
    }
    func test_closure_based_dependency_that_depends_on_another() async {

        let closure: @Sendable () -> ClosureBasedProtocol = {
            ClosureBasedImplemenation()
        }
        await sut.register(type: .closureBased(closure), for: ClosureBasedProtocol.self)

        guard let systemUnderTest = sut else {return}

         let anotherDependencyClosure: @Sendable () async -> AnotherDependencyProtocol = {
            //MARK: - Here will will resolve the closureBasedProtocol first to inject that into anotherDependency
             let service = await systemUnderTest.resolve(type: .closureBased, for: ClosureBasedProtocol.self)
            let anotherDependency = AnotherDependencyImplementation(service: service)
            return anotherDependency
        }
        //Register Dependency
        await sut.register(type: .closureBased(anotherDependencyClosure), for: AnotherDependencyProtocol.self)

        //Resolve Dependency
        let resolvedAnotherDependency = await sut.resolve(type: .closureBased, for: AnotherDependencyProtocol.self)

    }
}
