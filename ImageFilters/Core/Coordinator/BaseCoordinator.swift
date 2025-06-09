import UIKit

// MARK: - BaseCoordinator

class BaseCoordinator: NSObject, CoordinatorProtocol {
    // MARK: - Internal Properties

    var navigationController: UINavigationController?
    var children = [CoordinatorProtocol]()

    // MARK: - Init

    init(navigationController: UINavigationController?) {
        self.navigationController = navigationController
    }

    // MARK: - *CoordinatorProtocol

    func start() {
        fatalError("This method must be overridden")
    }

    // MARK: - Internal Methods

    func add(_ coordinator: CoordinatorProtocol) {
        children.append(coordinator)
    }

    func remove(_ coordinator: CoordinatorProtocol) {
        children = children.filter { coordinator !== $0 }
    }
}
