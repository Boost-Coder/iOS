//
//  MyPageViewController.swift
//  RankIn
//
//  Created by 조성민 on 4/6/24.
//

import UIKit
import RxSwift
import RxCocoa
import RxRelay

final class MyPageViewController: UIViewController {

    private let disposeBag = DisposeBag()
    
    // MARK: Input
    private let viewDidLoadPublish = PublishRelay<Void>()
    private let logoutPublish = PublishRelay<Void>()
    private let resignPublish = PublishRelay<Void>()
    
    private lazy var logOutButton: UIButton = {
        var attributedString = AttributedString("로그아웃")
        attributedString.font = UIFont.pretendard(type: .bold, size: 16)
        
        var configuration = UIButton.Configuration.filled()
        configuration.attributedTitle = attributedString
        configuration.baseForegroundColor = .black
        configuration.baseBackgroundColor = .white
        
        let button = UIButton(configuration: configuration)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.rx
            .tap
            .bind { _ in
                self.present(self.logOutAlert, animated: true)
            }
            .disposed(by: disposeBag)
        
        return button
    }()
    
    private lazy var resignButton: UIButton = {
        var attributedString = AttributedString("회원탈퇴")
        attributedString.font = UIFont.pretendard(type: .bold, size: 16)
        
        var configuration = UIButton.Configuration.filled()
        configuration.attributedTitle = attributedString
        configuration.baseForegroundColor = .black
        configuration.baseBackgroundColor = .white
        
        let button = UIButton(configuration: configuration)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.rx
            .tap
            .bind { _ in
                self.present(self.resignAlert, animated: true)
            }
            .disposed(by: disposeBag)
        
        return button
    }()
    
    private lazy var logOutAlert: UIAlertController = {
        let alert = UIAlertController(
            title: "로그아웃",
            message: "정말 로그아웃 하시겠습니까?",
            preferredStyle: .alert
        )
        let logout = UIAlertAction(title: "확인", style: .default) { action in
            self.logoutPublish.accept(())
        }
        let cancel = UIAlertAction(title: "취소", style: .cancel)
        
        alert.addAction(logout)
        alert.addAction(cancel)
        
        return alert
    }()
    
    private lazy var resignAlert: UIAlertController = {
        let alert = UIAlertController(
            title: "회원탈퇴",
            message: "정말 회원탈퇴 하시겠습니까?",
            preferredStyle: .alert
        )
        let logout = UIAlertAction(title: "탈퇴", style: .destructive) { action in
            self.resignPublish.accept(())
        }
        let cancel = UIAlertAction(title: "취소", style: .cancel)
        
        alert.addAction(logout)
        alert.addAction(cancel)
        
        return alert
    }()
    
    private let viewModel: MyPageViewModel
    
    init(viewModel: MyPageViewModel) {
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
        viewDidLoadPublish.accept(())
    }

}

private extension MyPageViewController {
    
    func setUI() {
        view.backgroundColor = .systemGray6
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.backgroundColor = .systemGray6
        
        setHierarchy()
        setConstraints()
    }
    
    func setHierarchy() {
        view.addSubview(logOutButton)
        view.addSubview(resignButton)
    }
    
    func setConstraints() {
        NSLayoutConstraint.activate([
            logOutButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            logOutButton.trailingAnchor.constraint(equalTo: view.centerXAnchor, constant: -10),
            logOutButton.widthAnchor.constraint(equalToConstant: 100),
            logOutButton.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        NSLayoutConstraint.activate([
            resignButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            resignButton.leadingAnchor.constraint(equalTo: view.centerXAnchor, constant: 10),
            resignButton.widthAnchor.constraint(equalToConstant: 100),
            resignButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    func bind() {
        let output = viewModel.transform(
            input: MyPageViewModelInput(
                viewDidLoad: viewDidLoadPublish,
                logout: logoutPublish,
                resign: resignPublish
            )
        )
        
        output.toLogin
            .subscribe { _ in
                self.dismiss(animated: true)
            } onError: { error in
                dump(error)
            }
            .disposed(by: disposeBag)
        
        output.myInformation
            .subscribe { information in
                dump(information)
            }
            .disposed(by: disposeBag)
    }
    
}
