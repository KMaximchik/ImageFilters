import UIKit

// MARK: - SceneDelegate

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    // MARK: - Internal Properties

    var window: UIWindow?

    // MARK: - Private Properties

    private var coordinator: CoordinatorProtocol?
    private var assembly: BaseAssembly?

    // MARK: - *UIWindowSceneDelegate

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        setupHome()
    }

    func sceneDidDisconnect(_ scene: UIScene) {}

    func sceneDidBecomeActive(_ scene: UIScene) {}

    func sceneWillResignActive(_ scene: UIScene) {}

    func sceneWillEnterForeground(_ scene: UIScene) {}

    func sceneDidEnterBackground(_ scene: UIScene) {}

    // MARK: - Private Methods

    private func setupHome() {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
            return
        }

        window = UIWindow(windowScene: windowScene)

        guard let window else { return }

        let assembly = HomeAssembly()
        coordinator = assembly.coordinator()

        guard let coordinator else { return }

        window.rootViewController = coordinator.navigationController
        self.window = window
        window.makeKeyAndVisible()
        coordinator.start()

        self.assembly = assembly
    }
}
