import UIKit

// MARK: - BaseAssemblyProtocol

protocol BaseAssemblyProtocol: AnyObject {
    func coordinator(navigationController: UINavigationController?) -> BaseCoordinator
    func coordinator() -> BaseCoordinator
}

// MARK: - BaseAssembly

class BaseAssembly: BaseAssemblyProtocol {
    // MARK: - Init

    required init() {}

    // MARK: - *BaseAssemblyProtocol

    func coordinator() -> BaseCoordinator {
        fatalError("this method must be overridden")
    }

    func coordinator(navigationController: UINavigationController?) -> BaseCoordinator {
        fatalError("this method must be overridden")
    }
}
