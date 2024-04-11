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
        
        let loginRepository = DefaultLoginRepository(
            session: AF
        )
        
        let appleLoginUseCase = DefaultAppleLoginUseCase(repository: loginRepository)
        
        let loginViewModelDependency = LoginViewModelDependency(
            appleLoginUseCase: appleLoginUseCase
        )
        
        let loginViewModel = DefaultLoginViewModel(dependency: loginViewModelDependency)
        
        let myPageViewController = MyPageViewController()
        let myPageNavigationController = UINavigationController(rootViewController: myPageViewController)
        
        let homeViewController = HomeViewController()
        let homeNavigationController = UINavigationController(rootViewController: homeViewController)
        
        let mainTabBarController = UITabBarController()
        mainTabBarController.modalPresentationStyle = .fullScreen
        mainTabBarController.modalTransitionStyle = .crossDissolve
        mainTabBarController.setViewControllers(
            [
                homeNavigationController,
                myPageNavigationController
            ],
            animated: true
        )
        
        if let items = mainTabBarController.tabBar.items {
            items[0].selectedImage = UIImage.systemImage(systemImage: .chartBar)
            items[0].image = UIImage.systemImage(systemImage: .chartBar)
            items[0].title = "Rank"
            
            items[1].selectedImage = UIImage.systemImage(systemImage: .person)
            items[1].image = UIImage.systemImage(systemImage: .person)
            items[1].title = "MyPage"
        }
        
        let loginViewController = LoginViewController(
            viewModel: loginViewModel,
            mainTabBarController: mainTabBarController
        )
        
        let splashViewController = SplashViewController(loginViewController: loginViewController)
        
        let window = UIWindow(windowScene: windowScene)
        window.rootViewController = splashViewController
        window.makeKeyAndVisible()
        
        self.window = window
    }

}
