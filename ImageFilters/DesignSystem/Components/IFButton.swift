import UIKit
import SnapKit

// MARK: - IFButton

final class IFButton: UIButton {
    // MARK: - Nested Types

    enum Size {
        case small, medium

        var height: CGFloat {
            switch self {
            case .small:
                28

            case .medium:
                36
            }
        }
    }

    // MARK: - Private Properties

    private let size: Size

    // MARK: - Init

    init(size: Size) {
        self.size = size
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
        titleLabel?.font = IFFont.footnote
        setTitleColor(IFColor.labelPrimaryInvariably, for: .normal)
        backgroundColor = IFColor.accentBlue
        layer.cornerRadius = size.height / 2
        contentEdgeInsets = UIEdgeInsets(top: .zero, left: 12, bottom: .zero, right: 12)
    }

    private func setupConstraints() {
        snp.makeConstraints {
            $0.height.equalTo(size.height)
        }
    }
}
