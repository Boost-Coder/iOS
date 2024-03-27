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
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false

        return button
    }()
    
    typealias ViewModel = LoginViewModel
    
    private let viewModel: ViewModel
    
    init(viewModel: ViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
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
        
    }
    
    func setConstraints() {
        
    }
    
    func bind() {
        let input = ViewModel.Input(
            appleLoginButtonTapped: appleLoginButton.rx.tap.asObservable()
        )
        
        let output = viewModel.transform(input: input)
        output.appleLoginOutput
            .bind {
                self.appleLogin()
            }
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
        print("애플 로그인 성공")
        // TODO: 로그인 성공시 데이터 처리
    }
    
    
    func authorizationController(
        controller: ASAuthorizationController,
        didCompleteWithError error: Error
    ) {
        print("애플 로그인 실패")
        // TODO: 로그인 실패 대응
    }
    
}
