import UIKit

// MARK: - HomeFilterCollectionViewCell

final class HomeFilterCollectionViewCell: UICollectionViewCell {
    // MARK: - Subviews Properties

    private lazy var imageContainerView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 8
        view.layer.borderWidth = 1
        view.layer.borderColor = IFColor.separatorSecondary?.withAlphaComponent(.zero).cgColor
        view.clipsToBounds = true

        return view
    }()

    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 8
        imageView.clipsToBounds = true

        return imageView
    }()

    private lazy var label: UILabel = {
        let label = UILabel()
        label.font = IFFont.captionSmall
        label.textColor = IFColor.labelSecondary
        label.textAlignment = .center

        return label
    }()

    // MARK: - Private Properties

    private var viewModel: ViewModel?

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
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
        setupGestures()
    }

    private func setupSubviews() {
        contentView.addSubviews(imageContainerView, label)
        imageContainerView.addSubview(imageView)
    }

    private func setupConstraints() {
        imageContainerView.snp.makeConstraints {
            $0.top.horizontalEdges.equalToSuperview()
            $0.width.equalTo(60)
            $0.height.equalTo(80)
        }

        imageView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(4)
        }

        label.snp.makeConstraints {
            $0.top.lessThanOrEqualTo(imageContainerView.snp.bottom).offset(4)
            $0.horizontalEdges.bottom.equalToSuperview()
        }
    }

    private func setupGestures() {
        contentView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapSelf)))
    }

    // MARK: - Actions

    @objc
    private func didTapSelf() {
        guard let viewModel else { return }

        viewModel.onSelect(viewModel.filterType)
    }
}

// MARK: - ConfigurableView

extension HomeFilterCollectionViewCell: ConfigurableView {
    func configure(with viewModel: HomeFilterCollectionViewCellModel) {
        self.viewModel = viewModel

        imageView.image = viewModel.image
        label.text = viewModel.filterType.name

        UIView.animate(withDuration: 0.3) {
            self.imageContainerView.layer.borderColor = IFColor.separatorSecondary?
                .withAlphaComponent(viewModel.isSelected ? 1 : .zero)
                .cgColor
        }
    }
}
