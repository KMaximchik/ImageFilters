import UIKit

// MARK: - IFBadgeView

final class IFBadgeView: UIView {
    // MARK: - Internal Properties

    var icon: UIImage? {
        get { iconImageView.image }
        set {
            iconImageView.isHidden = newValue == nil
            iconImageView.image = newValue
        }
    }

    var title: String? {
        get { titleLabel.text }
        set {
            titleLabel.isHidden = newValue == nil
            titleLabel.text = newValue
        }
    }

    // MARK: - Subviews Properties

    private lazy var containerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.alignment = .center
        stackView.spacing = 8
        stackView.backgroundColor = IFColor.backgroundPrimary
        stackView.layer.cornerRadius = 12
        stackView.layer.borderWidth = 1
        stackView.layer.borderColor = IFColor.separatorSecondary?.withAlphaComponent(0.4).cgColor
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = UIEdgeInsets(top: 8, left: 12, bottom: 8, right: 12)

        return stackView
    }()

    private lazy var iconImageView: UIImageView = {
        UIImageView()
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = IFFont.caption
        label.textColor = IFColor.labelSecondary

        return label
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
        containerStackView.addArrangedSubviews(iconImageView, titleLabel)
    }

    private func setupConstraints() {
        containerStackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
