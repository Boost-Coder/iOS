//
//  SceneDelegate.swift
//  RankIn
//
//  Created by 조성민 on 3/21/24.
//

import UIKit
import Alamofire

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let loginRepository = DefaultLoginRepository(session: AF)
        
        let appleLoginUseCase = DefaultAppleLoginUseCase(repository: loginRepository)
        
        let loginViewModelDependency = LoginViewModelDependency(
            appleLoginUseCase: appleLoginUseCase
        )
        
        let loginViewModel = DefaultLoginViewModel(dependency: loginViewModelDependency)
        
        let homeViewController = HomeViewController()
        let loginViewController = LoginViewController(viewModel: loginViewModel)
        
        let splashViewController = SplashViewController(loginViewController: loginViewController)
        
        let window = UIWindow(windowScene: windowScene)
        window.rootViewController = splashViewController
        window.makeKeyAndVisible()
        
        self.window = window
    }

}
