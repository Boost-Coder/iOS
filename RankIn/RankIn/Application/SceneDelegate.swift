//
//  SceneDelegate.swift
//  RankIn
//
//  Created by 조성민 on 3/21/24.
//

import UIKit
import Alamofire
import RxSwift
import RxRelay

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    let gitHubAuthorizationSuccess = PublishRelay<String>()

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let loginRepository = DefaultLoginRepository(
            session: AF
        )
        let signUpRepository = DefaultSignUpRepository(session: AF)
        
        let appleLoginUseCase = DefaultAppleLoginUseCase(
            repository: loginRepository
        )
        let sejongLoginUseCase = DefaultSejongLoginUseCase(
            repository: signUpRepository
        )
        let setGradeUseCase = DefaultSetGradeUseCase(
            repository: signUpRepository
        )
        let gitHubAuthorizationUseCase = DefaultGitHubAuthorizationUseCase(
            repository: signUpRepository
        )
        let gitHubAuthorizationRegisterUseCase = DefaultGitHubAuthorizationRegisterUseCase(
            repository: signUpRepository
        )
        
        let loginViewModelDependency = LoginViewModelDependency(
            appleLoginUseCase: appleLoginUseCase
        )
        let sejongLoginViewModelDependency = SejongLoginViewModelDependency(
            sejongLoginUseCase: sejongLoginUseCase
        )
        let gradeViewModelDependency = GradeViewModelDependency(
            setGradeUseCase: setGradeUseCase
        )
        let gitHubViewModelDependency = GitHubViewModelDependency(
            gitHubAuthorizationUseCase: gitHubAuthorizationUseCase, 
            gitHubAuthorizationRegisterUseCase: gitHubAuthorizationRegisterUseCase
        )
        
        let loginViewModel = DefaultLoginViewModel(
            dependency: loginViewModelDependency
        )
        let sejongLoginViewModel = DefaultSejongLoginViewModel(
            dependency: sejongLoginViewModelDependency
        )
        let gradeViewModel = DefaultGradeViewModel(
            dependency: gradeViewModelDependency
        )
        let gitHubViewModel = DefaultGitHubViewModel(
            dependency: gitHubViewModelDependency
        )
        
        let myPageViewController = MyPageViewController()
        let myPageNavigationController = UINavigationController(
            rootViewController: myPageViewController
        )
        let homeViewController = HomeViewController()
        let homeNavigationController = UINavigationController(
            rootViewController: homeViewController
        )
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
        let gitHubViewController = GitHubViewController(
            gitHubViewModel: gitHubViewModel,
            gitHubAuthorizationSuccess: gitHubAuthorizationSuccess,
            mainTabBarController: mainTabBarController
        )
        let gradeViewController = GradeViewController(
            gradeViewModel: gradeViewModel, 
            gitHubViewController: gitHubViewController
        )
        
        if let items = mainTabBarController.tabBar.items {
            items[0].selectedImage = UIImage.systemImage(systemImage: .chartBar)
            items[0].image = UIImage.systemImage(systemImage: .chartBar)
            items[0].title = "Rank"
            
            items[1].selectedImage = UIImage.systemImage(systemImage: .person)
            items[1].image = UIImage.systemImage(systemImage: .person)
            items[1].title = "MyPage"
        }
        
        
        let nicknameViewController = NicknameViewController(
            nicknameViewModel: DefaultNicknameViewModel(
                dependency: NicknameViewModelDependency(
                    setNicknameUseCase: DefaultSetNicknameUseCase(
                        repository: signUpRepository
                    )
                )
            ),
            gradeViewController: gradeViewController
        )
        let sejongLoginViewController = SejongLoginViewController(
            sejongLoginViewModel: sejongLoginViewModel,
            nicknameViewController: nicknameViewController
        )
        
        let signUpNavigationController = UINavigationController(
            rootViewController: sejongLoginViewController
        )
        signUpNavigationController.modalPresentationStyle = .fullScreen
        signUpNavigationController.modalTransitionStyle = .crossDissolve
        
        let loginViewController = LoginViewController(
            viewModel: loginViewModel,
            mainTabBarController: mainTabBarController,
            signUpNavigationController: signUpNavigationController
        )
        
        let splashViewController = SplashViewController(
            loginViewController: loginViewController
        )
        
        let window = UIWindow(
            windowScene: windowScene
        )
        window.rootViewController = splashViewController
//        window.rootViewController = gitHubViewController
        window.makeKeyAndVisible()
        
        self.window = window
    }
    
}

extension SceneDelegate {
    
    func scene(
        _ scene: UIScene,
        openURLContexts URLContexts: Set<UIOpenURLContext>
    ) {
        if let url = URLContexts.first?.url,
        let code = url.absoluteString.components(separatedBy: "code=").last {
            gitHubAuthorizationSuccess.accept(code)
        }
    }
    
}
