//
//  GitHubViewController.swift
//  RankIn
//
//  Created by 조성민 on 4/18/24.
//

import UIKit
import RxSwift
import RxRelay

final class GitHubViewController: UIViewController {
    
    private let disposeBag = DisposeBag()
    
    // MARK: Input
    let gitHubAuthorizationSuccess: PublishRelay<String>
    
    private lazy var gitHubButton: UIButton = {
        var attributedTitle = AttributedString("GitHub 인증")
        attributedTitle.font = UIFont.pretendard(type: .medium, size: 20)
        
        var configuration = UIButton.Configuration.filled()
        configuration.baseBackgroundColor = .gitHub
        configuration.baseForegroundColor = .white
        configuration.image = UIImage.gitHub
        configuration.imagePlacement = .leading
        configuration.attributedTitle = attributedTitle
        configuration.titleAlignment = .center
        configuration.imagePadding = 15
        
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.configuration = configuration
        
        return button
    }()
    
    private let skipButton: UIButton = {
        var attributeTitle = AttributedString("건너뛰기")
        attributeTitle.font = UIFont.pretendard(type: .regular, size: 15)
        
        var configuration = UIButton.Configuration.plain()
        configuration.attributedTitle = attributeTitle
        configuration.baseForegroundColor = .systemGray2
        
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.configuration = configuration
        
        return button
    }()
    
    private let viewModel: GitHubViewModel
    private let baekjoonViewController: BaekjoonViewController
    
    init(
        gitHubViewModel: GitHubViewModel,
        gitHubAuthorizationSuccess: PublishRelay<String>,
        baekjoonViewController: BaekjoonViewController
    ) {
        self.viewModel = gitHubViewModel
        self.gitHubAuthorizationSuccess = gitHubAuthorizationSuccess
        self.baekjoonViewController = baekjoonViewController
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        bind()
        react()
    }
    
}

private extension GitHubViewController {
    
    func setUI() {
        view.backgroundColor = .systemGray6
        
        setHierarchy()
        setConstraints()
    }
    
    func setHierarchy() {
        view.addSubview(gitHubButton)
        view.addSubview(skipButton)
    }
    
    func setConstraints() {
        NSLayoutConstraint.activate([
            gitHubButton.widthAnchor.constraint(equalToConstant: 285),
            gitHubButton.heightAnchor.constraint(equalToConstant: 44),
            gitHubButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            gitHubButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 258)
        ])
        
        NSLayoutConstraint.activate([
            skipButton.centerXAnchor.constraint(equalTo: gitHubButton.centerXAnchor),
            skipButton.topAnchor.constraint(equalTo: gitHubButton.bottomAnchor, constant: 5)
        ])
    }
    
    func bind() {
        let input = GitHubViewModelInput(
            gitHubAuthorizationSuccess: gitHubAuthorizationSuccess
        )
        
        let output = viewModel.transform(input: input)
        
        output.errorPublisher
            .bind { error in
                self.presentErrorToast(error: error)
            }
            .disposed(by: disposeBag)
        
        output.gitHubAuthorizationRegisterFailure
            .bind { _ in
                self.presentToast(toastCase: .gitHubAuthorizationFailed)
            }
            .disposed(by: disposeBag)
        
        output.gitHubAuthorizationRegisterSuccess
            .bind { _ in
                self.navigationController?.pushViewController(
                    self.baekjoonViewController, animated: true
                )
            }
            .disposed(by: disposeBag)
    }
    
    func react() {
        gitHubButton.rx
            .tap
            .bind { _ in
                guard let clientID = Bundle.main.object(
                    forInfoDictionaryKey: "GITHUB_CLIENT_ID"
                ) as? String else {
                    self.presentToast(toastCase: .gitHubAuthorizationFailed)
                    return
                }
                let urlString = "https://github.com/login/oauth/authorize?client_id=\(clientID)"
                guard let url = URL(string: urlString) else {
                    self.presentToast(toastCase: .gitHubAuthorizationFailed)
                    return
                }
                UIApplication.shared.open(url)
            }
            .disposed(by: disposeBag)
        
        skipButton.rx
            .tap
            .bind { _ in
                self.navigationController?.pushViewController(
                    self.baekjoonViewController, animated: true
                )
            }
            .disposed(by: disposeBag)
    }
    
}
