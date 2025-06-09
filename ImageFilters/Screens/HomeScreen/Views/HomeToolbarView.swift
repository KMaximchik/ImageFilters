import UIKit

// MARK: - HomeToolbarView

final class HomeToolbarView: UIView {
    // MARK: - Internal Properties

    var onTapPlusButton: () -> Void
    var onTapSaveButton: () -> Void

    // MARK: - Subviews Properties

    private lazy var containerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        stackView.spacing = 8
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = UIEdgeInsets(top: 12, left: 16, bottom: 12, right: 16)

        return stackView
    }()

    private lazy var plusButton: UIButton = {
        let button = UIButton()
        button.setImage(
            UIImage(
                systemName: "plus.app",
                withConfiguration: UIImage.SymbolConfiguration(font: IFFont.body)
            )?.withTintColor(
                IFColor.labelPrimary ?? .white,
                renderingMode: .alwaysOriginal
            ),
            for: .normal
        )
        button.addTarget(self, action: #selector(didTapPlusButton), for: .touchUpInside)

        return button
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Home.toolbar.title".localized()
        label.font = IFFont.footnote
        label.textColor = IFColor.labelSecondary
        label.textAlignment = .center

        return label
    }()

    private lazy var saveButton: UIButton = {
        let button = UIButton()
        button.setImage(
            UIImage(
                systemName: "square.and.arrow.down",
                withConfiguration: UIImage.SymbolConfiguration(font: IFFont.body)
            )?.withTintColor(
                IFColor.labelPrimary ?? .white,
                renderingMode: .alwaysOriginal
            ),
            for: .normal
        )
        button.addTarget(self, action: #selector(didTapSaveButton), for: .touchUpInside)

        return button
    }()

    // MARK: - Init

    init(
        onTapPlusButton: @escaping () -> Void,
        onTapSaveButton: @escaping () -> Void
    ) {
        self.onTapPlusButton = onTapPlusButton
        self.onTapSaveButton = onTapSaveButton
        super.init(frame: .zero)
        setupUI()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Private Methods

    private func setupUI() {
        setupSubviews()
        setupConstraints()
    }

    private func setupSubviews() {
        addSubview(containerStackView)
        containerStackView.addArrangedSubviews(plusButton, titleLabel, saveButton)
    }

    private func setupConstraints() {
        containerStackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        plusButton.snp.makeConstraints {
            $0.size.lessThanOrEqualTo(24)
        }

        saveButton.snp.makeConstraints {
            $0.size.lessThanOrEqualTo(24)
        }
    }

    // MARK: - Actions

    @objc
    private func didTapPlusButton() {
        onTapPlusButton()
    }

    @objc
    private func didTapSaveButton() {
        onTapSaveButton()
    }
}
