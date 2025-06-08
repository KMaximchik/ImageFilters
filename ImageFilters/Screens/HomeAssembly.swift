import UIKit

// MARK: - HomeAssemblyInterface

protocol HomeAssemblyInterface: AnyObject {
    func makeHome() -> HomeViewController
}

// MARK: - HomeAssembly

final class HomeAssembly: BaseAssembly {
    // MARK: - Init

    required init() {}

    // MARK: - *BaseAssembly

    override func coordinator(navigationController: UINavigationController?) -> BaseCoordinator {
        HomeCoordinator(assembly: self, navigationController: navigationController)
    }

    override func coordinator() -> BaseCoordinator {
        HomeCoordinator(assembly: self, navigationController: UINavigationController())
    }
}

// MARK: - HomeAssemblyInterface

extension HomeAssembly: HomeAssemblyInterface {
    func makeHome() -> HomeViewController {
        let viewModel = HomeViewModel()
        let viewController = HomeViewController(viewModel: viewModel)

        return viewController
    }
}
