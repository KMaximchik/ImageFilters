import UIKit

// MARK: - HomeViewController

final class HomeViewController: UIViewController {
    // MARK: - Private Properties

    private let viewModel: HomeViewModelInterface

    // MARK: - Init

    init(viewModel: HomeViewModelInterface) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }

    // MARK: - Private Methods

    private func setupUI() {}

    private func setupSubviews() {}

    private func setupConstraints() {}
}
