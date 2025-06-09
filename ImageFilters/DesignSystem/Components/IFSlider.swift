import UIKit

// MARK: - IFSlider

final class IFSlider: UISlider {
    // MARK: - *UISlider

    override func trackRect(forBounds bounds: CGRect) -> CGRect {
        let customHeight: CGFloat = 12
        let y = (bounds.height - customHeight) / 2
        return CGRect(x: bounds.origin.x, y: y, width: bounds.width, height: customHeight)
    }
}
