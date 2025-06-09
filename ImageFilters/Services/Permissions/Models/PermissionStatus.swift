// MARK: - PermissionStatus

enum PermissionStatus {
    case authorized, denied, notDetermined, restricted

    var granted: Bool {
        self == .authorized
    }
}
