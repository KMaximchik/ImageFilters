import UIKit

// MARK: - HomeCoordinator

final class HomeCoordinator: BaseCoordinator {
    // MARK: - Private Properties

    private weak var assembly: HomeAssemblyInterface?

    // MARK: - Init

    init(assembly: HomeAssemblyInterface, navigationController: UINavigationController?) {
        self.assembly = assembly
        super.init(navigationController: navigationController)
    }

    // MARK: - *BaseCoordinator

    override func start() {
        showHome()
    }

    // MARK: - Private Methods

    private func showHome() {
        guard let home = assembly?.makeHome() else { return }

        navigationController?.pushViewController(home, animated: true)
    }
}
