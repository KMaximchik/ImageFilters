import UIKit

// MARK: - IFResizableImageView

final class IFResizableImageView: UIView {
    // MARK: - Internal Properties

    var image: UIImage? {
        get { imageView.image }
        set { imageView.image = newValue }
    }

    // MARK: - Subviews Properties

    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.isUserInteractionEnabled = true

        return imageView
    }()

    // MARK: - Private Properties

    private var scale: CGFloat = 1
    private var rotation = CGFloat.zero
    private var offset = CGPoint.zero
    private let minScale: CGFloat = 1
    private let maxScale: CGFloat = 3

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
        setupGestures()
    }

    private func setupSubviews() {
        clipsToBounds = true

        addSubview(imageView)
    }

    private func setupConstraints() {
        imageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

    private func setupGestures() {
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(didChangePinchGesture(_:)))
        let rotationGesture = UIRotationGestureRecognizer(target: self, action: #selector(didChangeRotationGesture(_:)))
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(didChangePanGesture(_:)))

        pinchGesture.delegate = self
        rotationGesture.delegate = self
        panGesture.delegate = self

        addGestureRecognizer(pinchGesture)
        addGestureRecognizer(rotationGesture)
        addGestureRecognizer(panGesture)
    }

    private func applyTransform(animated: Bool = false) {
        let transform = CGAffineTransform.identity
            .translatedBy(x: offset.x, y: offset.y)
            .rotated(by: rotation)
            .scaledBy(x: scale, y: scale)

        if animated {
            UIView.animate(
                withDuration: 0.3,
                delay: .zero,
                usingSpringWithDamping: 0.8,
                initialSpringVelocity: 1
            ) {
                self.imageView.transform = transform
            }
        } else {
            imageView.transform = transform
        }
    }

    private func resetAnimated() {
        scale = 1.0
        rotation = .zero
        offset = .zero
        applyTransform(animated: true)
    }

    private func validateAndResetIfNeeded() {
        var shouldReset = false

        if abs(offset.x) > .zero || abs(offset.y) > .zero {
            shouldReset = true
        }

        if abs(rotation) > CGFloat.pi / 4 {
            shouldReset = true
        }

        guard shouldReset else { return }

        resetAnimated()
    }

    // MARK: - Actions

    @objc
    private func didChangePinchGesture(_ gesture: UIPinchGestureRecognizer) {
        scale *= gesture.scale
        scale = min(max(scale, minScale), maxScale)
        gesture.scale = 1
        applyTransform()

        guard gesture.state == .ended else { return }

        validateAndResetIfNeeded()
    }

    @objc
    private func didChangeRotationGesture(_ gesture: UIRotationGestureRecognizer) {
        rotation += gesture.rotation
        gesture.rotation = .zero
        applyTransform()

        guard gesture.state == .ended else { return }

        validateAndResetIfNeeded()
    }

    @objc
    private func didChangePanGesture(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: self)
        offset.x += translation.x
        offset.y += translation.y
        gesture.setTranslation(.zero, in: self)
        applyTransform()

        guard gesture.state == .ended else { return }

        validateAndResetIfNeeded()
    }
}

// MARK: - UIGestureRecognizerDelegate

extension IFResizableImageView: UIGestureRecognizerDelegate {
    func gestureRecognizer(
        _ gestureRecognizer: UIGestureRecognizer,
        shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer
    ) -> Bool {
        true
    }
}
