import UIKit
import SnapKit

// MARK: - IFEmptyStateView

final class IFEmptyStateView: UIView {
    // MARK: - Internal Properties

    var icon: UIImage? {
        get { iconImageView.image }
        set {
            iconImageView.image = newValue
            iconImageView.isHidden = newValue == nil
        }
    }

    var title: String? {
        get { titleLabel.text }
        set {
            titleLabel.text = newValue
            titleLabel.isHidden = newValue == nil
        }
    }

    var subtitle: String? {
        get { subtitleLabel.text }
        set {
            subtitleLabel.text = newValue
            subtitleLabel.isHidden = newValue == nil
        }
    }

    var buttonTitle: String? {
        get { button.titleLabel?.text }
        set {
            button.setTitle(newValue, for: .normal)
            button.isHidden = newValue == nil
        }
    }

    var onTapButton: (() -> Void)?

    // MARK: - Subviews Properties

    private lazy var containerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center

        return stackView
    }()

    private lazy var iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.isHidden = true

        return imageView
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = IFFont.callout
        label.textColor = IFColor.labelPrimary
        label.textAlignment = .center
        label.numberOfLines = .zero
        label.isHidden = true

        return label
    }()

    private lazy var subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = IFFont.footnote
        label.textColor = IFColor.labelSecondary
        label.textAlignment = .center
        label.numberOfLines = .zero
        label.isHidden = true

        return label
    }()

    private lazy var button: IFButton = {
        let button = IFButton(size: .medium)
        button.isHidden = true
        button.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)

        return button
    }()

    // MARK: - Init

    init() {
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
        containerStackView.addArrangedSubviews(
            iconImageView,
            titleLabel,
            subtitleLabel,
            button
        )
    }

    private func setupConstraints() {
        containerStackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        containerStackView.setCustomSpacing(24, after: iconImageView)
        containerStackView.setCustomSpacing(8, after: titleLabel)
        containerStackView.setCustomSpacing(16, after: subtitleLabel)
    }

    // MARK: - Actions

    @objc
    private func didTapButton() {
        onTapButton?()
    }
}
