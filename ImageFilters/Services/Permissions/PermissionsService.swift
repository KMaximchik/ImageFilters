import Photos
import AVFoundation
import Foundation

// MARK: - PermissionsServiceInterface

protocol PermissionsServiceInterface: AnyObject {
    func request(_ type: PermissionType, completion: @escaping (PermissionStatus) -> Void)
}

// MARK: - PermissionsService

final class PermissionsService {
    // MARK: - Private Methods

    private func requestGalleryPermissionStatus(completion: @escaping (PermissionStatus) -> Void) {
        PHPhotoLibrary.requestAuthorization(for: .readWrite) { [weak self] status in
            DispatchQueue.main.async {
                completion(self?.mapGalleryPermissionStatus(status) ?? .denied)
            }
        }
    }

    private func mapGalleryPermissionStatus(_ status: PHAuthorizationStatus) -> PermissionStatus {
        switch PHPhotoLibrary.authorizationStatus(for: .readWrite) {
        case .authorized, .limited:
            return .authorized

        case .denied:
            return .denied

        case .restricted:
            return .restricted

        case .notDetermined:
            return .notDetermined

        @unknown default:
            return .denied
        }
    }
}

// MARK: - PermissionsServiceInterface

extension PermissionsService: PermissionsServiceInterface {
    func request(_ type: PermissionType, completion: @escaping (PermissionStatus) -> Void) {
        switch type {
        case .gallery:
            requestGalleryPermissionStatus(completion: completion)
        }
    }
}
