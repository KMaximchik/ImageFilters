import UIKit

// MARK: - FiltersServiceInterface

protocol FiltersServiceInterface: AnyObject {
    func applyFilter(
        _ filter: FilterType,
        to ciImage: CIImage,
        with intensity: Float,
        scale: CGFloat,
        orientation: UIImage.Orientation
    ) -> UIImage?
}

// MARK: - FiltersService

final class FiltersService {
    // MARK: - Private Properties

    private let ciContext = CIContext()

    // MARK: - Private Methods

    private func applySepiaTone(
        to ciImage: CIImage,
        with intensity: Float,
        scale: CGFloat,
        orientation: UIImage.Orientation
    ) -> UIImage? {
        let filter = CIFilter.sepiaTone()
        filter.inputImage = ciImage
        filter.intensity = intensity

        guard let ciImage = filter.outputImage else { return nil }

        return convertToUiImage(
            ciImage: ciImage,
            scale: scale,
            orientation: orientation
        )
    }

    private func applyVignette(
        to ciImage: CIImage,
        with intensity: Float,
        scale: CGFloat,
        orientation: UIImage.Orientation
    ) -> UIImage? {
        let filter = CIFilter.vignette()
        filter.inputImage = ciImage
        filter.intensity = intensity * 10 + 3

        guard let ciImage = filter.outputImage else { return nil }

        return convertToUiImage(
            ciImage: ciImage,
            scale: scale,
            orientation: orientation
        )
    }

    private func applyContrast(
        to ciImage: CIImage,
        with contrast: Float,
        scale: CGFloat,
        orientation: UIImage.Orientation
    ) -> UIImage? {
        let filter = CIFilter.colorControls()
        filter.inputImage = ciImage
        filter.contrast = contrast * 2.5 + 1

        guard let ciImage = filter.outputImage else { return nil }

        return convertToUiImage(
            ciImage: ciImage,
            scale: scale,
            orientation: orientation
        )
    }

    private func convertToUiImage(
        ciImage: CIImage,
        scale: CGFloat,
        orientation: UIImage.Orientation
    ) -> UIImage? {
        guard let cgImage = ciContext.createCGImage(ciImage, from: ciImage.extent) else { return nil }

        return UIImage(cgImage: cgImage, scale: scale, orientation: orientation)
    }
}

// MARK: - FiltersServiceInterface

extension FiltersService: FiltersServiceInterface {
    func applyFilter(
        _ filter: FilterType,
        to ciImage: CIImage,
        with intensity: Float,
        scale: CGFloat,
        orientation: UIImage.Orientation
    ) -> UIImage? {
        switch filter {
        case .original:
            UIImage(ciImage: ciImage)

        case .sepiaTone:
            applySepiaTone(to: ciImage, with: intensity, scale: scale, orientation: orientation)

        case .vignette:
            applyVignette(to: ciImage, with: intensity, scale: scale, orientation: orientation)

        case .contrast:
            applyContrast(to: ciImage, with: intensity, scale: scale, orientation: orientation)
        }
    }
}
