//
//  SceneDelegate.swift
//  RankIn
//
//  Created by 조성민 on 3/21/24.
//

import UIKit

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let homeViewController = HomeViewController()
        let splashViewController = SplashViewController(homeViewController: homeViewController)
        
        let window = UIWindow(windowScene: windowScene)
        window.rootViewController = splashViewController
        window.makeKeyAndVisible()
        
        self.window = window
    }

}
