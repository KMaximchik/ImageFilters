import Foundation
import UIKit
import UniformTypeIdentifiers

// MARK: - HomeCoordinator

final class HomeCoordinator: BaseCoordinator {
    // MARK: - Private Properties

    private weak var assembly: HomeAssemblyInterface?

    private weak var homeInput: HomeInputInterface?

    // MARK: - Init

    init(assembly: HomeAssemblyInterface, navigationController: UINavigationController?) {
        self.assembly = assembly
        super.init(navigationController: navigationController)
    }

    // MARK: - *BaseCoordinator

    override func start() {
        showHome()
    }

    // MARK: - Private Methods

    private func showHome() {
        guard let home = assembly?.makeHome(output: self) else { return }

        homeInput = home.input

        navigationController?.pushViewController(home.viewController, animated: true)
    }

    private func showImagePicker(
        sourceType: UIImagePickerController.SourceType,
        mediaTypes: [String],
        allowsEditing: Bool = false
    ) {
        guard UIImagePickerController.isSourceTypeAvailable(sourceType) else { return }

        let imagePickerController = UIImagePickerController()
        imagePickerController.mediaTypes = mediaTypes
        imagePickerController.sourceType = sourceType
        imagePickerController.allowsEditing = allowsEditing
        imagePickerController.delegate = self
        navigationController?.present(imagePickerController, animated: true)
    }

    private func showAlert(
        title: String?,
        message: String?,
        actions: [UIAlertAction],
        style: UIAlertController.Style
    ) {
        let alertController = UIAlertController(
            title: title,
            message: message,
            preferredStyle: style
        )
        actions.forEach { alertController.addAction($0) }

        navigationController?.present(alertController, animated: true)
    }

    private func openUrl(_ url: URL) {
        UIApplication.shared.open(url)
    }
}

// MARK: - UINavigationControllerDelegate

extension HomeCoordinator: UINavigationControllerDelegate {}

// MARK: - UIImagePickerControllerDelegate

extension HomeCoordinator: UIImagePickerControllerDelegate {
    func imagePickerController(
        _ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]
    ) {
        if let image = info[.originalImage] as? UIImage {
            homeInput?.setSelectedImage(image)
            picker.dismiss(animated: true, completion: nil)
        }
    }
}

// MARK: - HomeOutputInterface

extension HomeCoordinator: HomeOutputInterface {
    func homeShowImagePicker() {
        showImagePicker(sourceType: .photoLibrary, mediaTypes: [UTType.image.identifier])
    }

    func homeShowAlert(
        title: String?,
        message: String?,
        actions: [UIAlertAction],
        style: UIAlertController.Style = .alert
    ) {
        showAlert(
            title: title,
            message: message,
            actions: actions,
            style: style
        )
    }

    func homeOpenUrl(_ url: URL) {
        openUrl(url)
    }
}
