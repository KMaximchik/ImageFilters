import UIKit

// MARK: - CoordinatorProtocol

protocol CoordinatorProtocol: AnyObject {
    var navigationController: UINavigationController? { get }
    var children: [CoordinatorProtocol] { get }

    func start()
}
