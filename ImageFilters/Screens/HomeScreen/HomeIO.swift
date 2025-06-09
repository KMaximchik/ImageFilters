import Foundation
import UIKit

// MARK: - HomeOutputInterface

protocol HomeOutputInterface: AnyObject {
    func homeShowImagePicker()
    func homeShowAlert(
        title: String?,
        message: String?,
        actions: [UIAlertAction],
        style: UIAlertController.Style
    )
    func homeOpenUrl(_ url: URL)
}

// MARK: - HomeInputInterface

protocol HomeInputInterface: AnyObject {
    func setSelectedImage(_ image: UIImage)
}
