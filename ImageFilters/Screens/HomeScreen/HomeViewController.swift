import UIKit
import SnapKit
import Combine

// MARK: - HomeViewController

final class HomeViewController: UIViewController {
    // MARK: - Subviews Properties

    private lazy var emptyStateView: IFEmptyStateView = {
        let emptyStateView = IFEmptyStateView()
        emptyStateView.icon = UIImage(
            systemName: "photo.on.rectangle.angled",
            withConfiguration: UIImage.SymbolConfiguration(font: IFFont.largeTitle)
        )?.withTintColor(
            IFColor.accentBlue ?? .white,
            renderingMode: .alwaysOriginal
        )
        emptyStateView.title = "Home.emptyState.title".localized()
        emptyStateView.subtitle = "Home.emptyState.subtitle".localized()
        emptyStateView.buttonTitle = "Home.emptyState.button.title".localized()
        emptyStateView.onTapButton = { [weak self] in
            self?.viewModel.didTapSelectButton()
        }

        return emptyStateView
    }()

    private lazy var containerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 12
        stackView.isHidden = true

        return stackView
    }()

    private lazy var imageContainerView: UIView = {
        UIView()
    }()

    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 24
        imageView.clipsToBounds = true

        return imageView
    }()

    private lazy var sliderContainerView: UIView = {
        UIView()
    }()

    private lazy var slider: IFSlider = {
        let slider = IFSlider()
        slider.minimumValue = .zero
        slider.maximumValue = 1
        slider.value = slider.maximumValue
        slider.thumbTintColor = IFColor.labelPrimaryInvariably
        slider.minimumTrackTintColor = IFColor.accentBlue
        slider.maximumTrackTintColor = IFColor.backgroundSecondary
        slider.addTarget(self, action: #selector(didChangeSliderValue), for: .valueChanged)

        return slider
    }()

    private lazy var additionalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.backgroundColor = IFColor.backgroundSecondary
        stackView.axis = .vertical
        stackView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        stackView.layer.cornerRadius = 16
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = UIEdgeInsets(top: 16, left: .zero, bottom: .zero, right: .zero)

        return stackView
    }()

    private lazy var filtersCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
        collectionView.delegate = self
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.bounces = false
        collectionView.backgroundColor = .clear
        collectionView.register(class: HomeFilterCollectionViewCell.self)

        return collectionView
    }()

    private lazy var homeToolbarView: HomeToolbarView = {
        let toolbarView = HomeToolbarView(
            onTapPlusButton: { [weak self] in
                self?.viewModel.didTapPlusButton()
            },
            onTapSaveButton: { [weak self] in
                self?.viewModel.didTapSaveButton()
            }
        )

        return toolbarView
    }()

    private lazy var badgeView: IFBadgeView = {
        let badgeView = IFBadgeView()
        badgeView.alpha = .zero

        return badgeView
    }()

    private lazy var collectionDataSource = getCollectionDataSource()

    // MARK: - Private Properties

    private var cancellables = Set<AnyCancellable>()

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
        setupBindings()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        navigationController?.navigationBar.isHidden = true
    }

    // MARK: - Private Methods

    private func setupUI() {
        setupSubviews()
        setupConstraints()
    }

    private func setupSubviews() {
        view.backgroundColor = IFColor.backgroundPrimary

        view.addSubviews(emptyStateView, containerStackView, badgeView)
        containerStackView.addArrangedSubviews(
            imageContainerView,
            sliderContainerView,
            additionalStackView
        )
        sliderContainerView.addSubview(slider)
        imageContainerView.addSubview(imageView)
        additionalStackView.addArrangedSubviews(filtersCollectionView, homeToolbarView)

        filtersCollectionView.dataSource = collectionDataSource
        filtersCollectionView.setCollectionViewLayout(getCollectionViewLayout(), animated: false)
    }

    private func setupConstraints() {
        emptyStateView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.centerY.equalToSuperview()
        }

        containerStackView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.horizontalEdges.bottom.equalToSuperview()
        }

        imageView.snp.makeConstraints {
            $0.verticalEdges.equalToSuperview()
            $0.horizontalEdges.equalToSuperview().inset(16)
        }

        slider.snp.makeConstraints {
            $0.verticalEdges.equalToSuperview()
            $0.width.equalToSuperview().multipliedBy(0.6)
            $0.centerX.equalToSuperview()
        }

        filtersCollectionView.snp.makeConstraints {
            $0.height.equalTo(100)
        }

        badgeView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(16)
            $0.centerX.equalToSuperview()
        }
    }

    private func getCollectionDataSource() -> CollectionDataSource {
        CollectionDataSource(
            collectionView: filtersCollectionView
        ) { collectionView, indexPath, row -> UICollectionViewCell? in
            row.model.configure(collectionView: collectionView, for: indexPath)
        }
    }

    private func getCollectionViewLayout() -> UICollectionViewCompositionalLayout {
        UICollectionViewCompositionalLayout { _, _ -> NSCollectionLayoutSection? in
            IFCollectionLayout.horizontalLayout(
                cellWidth: .absolute(60),
                cellHeight: .absolute(100),
                contentInset: NSDirectionalEdgeInsets(top: .zero, leading: 16, bottom: .zero, trailing: 16),
                interGroupSpacing: 8
            )
        }
    }

    private func setupBindings() {
        viewModel.filteredImagePublisher
            .receive(on: RunLoop.main)
            .sink { [weak self] image in
                guard let self else { return }

                self.emptyStateView.isHidden = image != nil
                self.containerStackView.isHidden = image == nil

                UIView.transition(with: self.imageView, duration: 0.3, options: .transitionCrossDissolve) {
                    self.imageView.image = image
                }
            }
            .store(in: &cancellables)

        viewModel.collectionSectionsPublisher
            .receive(on: RunLoop.main)
            .sink { [weak self] collectionSections in
                self?.reloadData(with: collectionSections)
            }
            .store(in: &cancellables)

        viewModel.selectedFilterPublisher
            .receive(on: RunLoop.main)
            .sink { [weak self] selectedFilter in
                self?.slider.alpha = selectedFilter == .original ? .zero : 1
            }
            .store(in: &cancellables)

        viewModel.imageSavingPublisher
            .receive(on: RunLoop.main)
            .sink { [weak self] success in
                self?.badgeView.icon = UIImage(
                    systemName: success ? "checkmark.circle.fill" : "exclamationmark.triangle.fill",
                    withConfiguration: UIImage.SymbolConfiguration(font: IFFont.footnote)
                )?.withTintColor(
                    (success ? IFColor.accentGreen : IFColor.accentRed) ?? .white,
                    renderingMode: .alwaysOriginal
                )

                self?.badgeView.title = success
                ? "Home.badge.success.title".localized()
                : "Home.badge.failure.title".localized()

                self?.showBadge()
            }
            .store(in: &cancellables)
    }

    private func reloadData(with collectionSections: [CollectionSection]) {
        var snapshot = CollectionSnapshot()
        collectionSections.forEach {
            snapshot.appendSections([$0])
            snapshot.appendItems($0.rowsModels, toSection: $0)
        }
        collectionDataSource.apply(snapshot, animatingDifferences: true)
    }

    private func showBadge() {
        UIView.transition(with: badgeView, duration: 0.3, options: .transitionCrossDissolve) {
            self.badgeView.alpha = 1
        } completion: { _ in
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                self.badgeView.alpha = .zero
            }
        }
    }

    // MARK: - Actions

    @objc
    private func didChangeSliderValue() {
        viewModel.didChangeSliderValue(slider.value)
    }
}

// MARK: - UICollectionViewDelegate

extension HomeViewController: UICollectionViewDelegate {}
