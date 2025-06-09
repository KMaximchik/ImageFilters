import CoreImage.CIFilterBuiltins

// MARK: - FilterType

enum FilterType: String, CaseIterable {
    case original, sepiaTone, vignette, contrast

    var name: String {
        switch self {
        case .original:
            "Common.filter.original.title".localized()

        case .sepiaTone:
            "Common.filter.sepiaTone.title".localized()

        case .vignette:
            "Common.filter.vignette.title".localized()

        case .contrast:
            "Common.filter.contrast.title".localized()
        }
    }

    var defaultIntensivity: Float {
        switch self {
        case .original, .sepiaTone, .vignette:
            return 1

        case .contrast:
            return .zero
        }
    }
}
