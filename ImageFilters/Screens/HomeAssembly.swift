import UIKit

// MARK: - HomeAssemblyInterface

protocol HomeAssemblyInterface: AnyObject {
    func makeHome(
        output: HomeOutputInterface
    ) -> (viewController: HomeViewController, input: HomeInputInterface)
}

// MARK: - HomeAssembly

final class HomeAssembly: BaseAssembly {
    // MARK: - Private Properties

    private let servicesAssembly: ServicesAssemblyInterface

    // MARK: - Init

    init(servicesAssembly: ServicesAssemblyInterface) {
        self.servicesAssembly = servicesAssembly
    }

    @available(*, unavailable)
    required init() {
        fatalError("init() has not been implemented")
    }

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
    func makeHome(
        output: HomeOutputInterface
    ) -> (viewController: HomeViewController, input: HomeInputInterface) {
        let viewModel = HomeViewModel(
            permissionsService: servicesAssembly.permissionsService,
            filtersService: servicesAssembly.filtersService,
            output: output
        )
        let viewController = HomeViewController(viewModel: viewModel)

        return (viewController: viewController, input: viewModel)
    }
}
