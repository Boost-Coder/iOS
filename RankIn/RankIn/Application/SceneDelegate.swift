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
        
        let userRepository = DefaultUserRepository(
            session: AF
        )
        let signUpRepository = DefaultSignUpRepository(session: AF)
        let rankRepository = DefaultRankRepository(session: AF)
        
        let appleLoginUseCase = DefaultAppleLoginUseCase(
            repository: userRepository
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
        let setBaekjoonIDUseCase = DefaultSetBaekjoonIDUseCase(
            repository: signUpRepository
        )
        let fetchRankListUseCase = DefaultFetchRankListUseCase(repository: rankRepository)
        let fetchMyInfromationUseCase = DefaultFetchMyInformationUseCase(repository: userRepository)
        let logOutUseCase = DefaultLogOutUseCase(repository: userRepository)
        let resignUseCase = DefaultResignUseCase(repository: userRepository)
        let fetchMyStatUseCase = DefaultFetchMyStatUseCase(repository: userRepository)
        let fetchMyRankUseCase = DefaultFetchMyRankUseCase(repository: rankRepository)
        
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
        let baekjoonViewModelDependency = BaekjoonViewModelDependency(
            setBaekjoonIDUseCase: setBaekjoonIDUseCase
        )
        let myPageViewModelDependency = MyPageViewModelDependency(
            fetchMyInfromationUseCase: fetchMyInfromationUseCase,
            fetchMyStatUseCase: fetchMyStatUseCase,
            logOutUseCase: logOutUseCase,
            resignUseCase: resignUseCase
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
        let baekjoonViewModel = DefaultBaekjoonViewModel(
            dependency: baekjoonViewModelDependency
        )
        let homeViewModel = DefaultHomeViewModel(
            dependency: HomeViewModelDependency(
                fetchRankListUseCase: fetchRankListUseCase,
                fetchMyRankUseCase: fetchMyRankUseCase
            )
        )
        let myPageViewModel = DefaultMyPageViewModel(dependency: myPageViewModelDependency)
        
        let myPageViewController = MyPageViewController(viewModel: myPageViewModel)
        let myPageNavigationController = UINavigationController(
            rootViewController: myPageViewController
        )
        let homeViewController = HomeViewController(viewModel: homeViewModel)
        let homeNavigationController = UINavigationController(
            rootViewController: homeViewController
        )
        
        let tabBarAppearance = UITabBarAppearance()
        tabBarAppearance.configureWithOpaqueBackground()
        tabBarAppearance.backgroundColor = .systemGray4
        let mainTabBarController = UITabBarController()
        mainTabBarController.modalPresentationStyle = .fullScreen
        mainTabBarController.modalTransitionStyle = .crossDissolve
        mainTabBarController.tabBar.tintColor = .sejongPrimary
        mainTabBarController.tabBar.isTranslucent = false
        mainTabBarController.tabBar.backgroundColor = .systemGray4
        mainTabBarController.tabBar.standardAppearance = tabBarAppearance
        mainTabBarController.setViewControllers(
            [
                homeNavigationController,
                myPageNavigationController
            ],
            animated: true
        )
        let baekjoonViewController = BaekjoonViewController(
            baekjoonViewModel: baekjoonViewModel,
            mainTabBarController: mainTabBarController
        )
        let gitHubViewController = GitHubViewController(
            gitHubViewModel: gitHubViewModel,
            gitHubAuthorizationSuccess: gitHubAuthorizationSuccess,
            baekjoonViewController: baekjoonViewController
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
