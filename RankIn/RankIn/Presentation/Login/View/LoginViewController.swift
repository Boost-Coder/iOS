//
//  LoginViewController.swift
//  RankIn
//
//  Created by 조성민 on 3/27/24.
//

import UIKit
import RxCocoa
import RxSwift
import AuthenticationServices

final class LoginViewController: UIViewController {
    
    private let disposeBag = DisposeBag()
    
    private lazy var appleLoginButton: UIButton = {
        var attributedTitle = AttributedString("Apple 로그인")
        attributedTitle.font = UIFont.pretendard(type: .medium, size: 20)
        
        var configuration = UIButton.Configuration.filled()
        configuration.baseBackgroundColor = .white
        configuration.baseForegroundColor = .black
        configuration.image = UIImage.systemImage(systemImage: .appleLogo)
        configuration.imagePlacement = .leading
        configuration.attributedTitle = attributedTitle
        configuration.titleAlignment = .center
        configuration.imagePadding = 15
        
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.configuration = configuration
        
        return button
    }()
    
    typealias ViewModel = LoginViewModel
    
    private let viewModel: ViewModel
    
    init(viewModel: ViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
        self.modalPresentationStyle = .fullScreen
        self.modalTransitionStyle = .crossDissolve
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        react()
        bind()
    }
    
}

private extension LoginViewController {
    
    func setUI() {
        view.backgroundColor = .systemGray6
        
        setHierarchy()
        setConstraints()
    }
    
    func setHierarchy() {
        view.addSubview(appleLoginButton)
    }
    
    func setConstraints() {
        NSLayoutConstraint.activate([
            appleLoginButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 42),
            appleLoginButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -42),
            appleLoginButton.heightAnchor.constraint(equalToConstant: 54),
            appleLoginButton.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    func bind() {
        let input = ViewModel.Input(
        )
        
        let output = viewModel.transform(input: input)
    }
    
    func react() {
        appleLoginButton.rx
            .tap
            .bind(onNext: { _ in
                self.appleLogin()
            })
            .disposed(by: disposeBag)
    }
    
}

extension LoginViewController: ASAuthorizationControllerDelegate {
    
    func appleLogin() {
        let request = ASAuthorizationAppleIDProvider().createRequest()
        request.requestedScopes = [.fullName, .email]
        
        let controller = ASAuthorizationController(authorizationRequests: [request])
        controller.delegate = self
        controller.presentationContextProvider = self as? ASAuthorizationControllerPresentationContextProviding
        controller.performRequests()
    }
    
    func authorizationController(
        controller: ASAuthorizationController,
        didCompleteWithAuthorization authorization: ASAuthorization
    ) {
        switch authorization.credential {
        // MARK: 애플 로그인 성공
        case let appleIDCredential as ASAuthorizationAppleIDCredential:
            let userIdentifier = appleIDCredential.user
            let fullName = appleIDCredential.fullName
            let email = appleIDCredential.email
            
            if  let authorizationCode = appleIDCredential.authorizationCode,
                let identityToken = appleIDCredential.identityToken,
                let authString = String(data: authorizationCode, encoding: .utf8),
                let tokenString = String(data: identityToken, encoding: .utf8) {
                // TODO: server로 authString, tokenString을 보내서 jwt 발급받아서 저장해야 한다.
            }
        // MARK: iCloud 비밀번호 연동
        case let passwordCredential as ASPasswordCredential:
            let username = passwordCredential.user
            let password = passwordCredential.password
            
            print("username: \(username)")
            print("password: \(password)")
        default:
            break
        }
    }
    
    
    func authorizationController(
        controller: ASAuthorizationController,
        didCompleteWithError error: Error
    ) {
        // TODO: 로그인 실패 대응
        print("애플 로그인 실패")
    }
    
}