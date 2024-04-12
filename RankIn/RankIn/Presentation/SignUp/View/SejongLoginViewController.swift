//
//  SejongLoginViewController.swift
//  RankIn
//
//  Created by 조성민 on 4/13/24.
//

import UIKit
import RxSwift
import RxRelay

final class SejongLoginViewController: UIViewController {

    private let disposeBag = DisposeBag()
    
    // MARK: Input
    private let loginButtonTapped = PublishRelay<SejongLoginInfo>()
    
    private let id: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 25, height: textField.bounds.height))
        textField.leftViewMode = .always
        textField.rightView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: textField.bounds.height))
        textField.rightViewMode = .always
        textField.layer.cornerRadius = 6
        textField.backgroundColor = .white
        textField.textColor = .black
        textField.attributedPlaceholder = NSAttributedString(
            string: "학번",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemGray]
        )

        return textField
    }()
    
    private let password: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 25, height: textField.bounds.height))
        textField.leftViewMode = .always
        textField.rightView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: textField.bounds.height))
        textField.leftViewMode = .always
        textField.layer.cornerRadius = 6
        textField.backgroundColor = .white
        textField.textColor = .black
        textField.attributedPlaceholder = NSAttributedString(
            string: "비밀번호",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemGray]
        )
        textField.isSecureTextEntry = true
        
        return textField
    }()
    
    private let loginButton: UIButton = {
        var attributeTitle = AttributedString("로그인")
        attributeTitle.font = UIFont.pretendard(type: .semiBold, size: 17)
        
        var configuration = UIButton.Configuration.filled()
        configuration.attributedTitle = attributeTitle
        configuration.baseBackgroundColor = .systemGray
        
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.configuration = configuration
        
        return button
    }()
    
    private let viewModel: SejongLoginViewModel
    
    init(sejongLoginViewModel: SejongLoginViewModel) {
        self.viewModel = sejongLoginViewModel
        
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

private extension SejongLoginViewController {
    
    func setUI() {
        view.backgroundColor = .systemGray6
        
        setHierarchy()
        setConstraints()
    }
    
    func setHierarchy() {
        view.addSubview(id)
        view.addSubview(password)
        view.addSubview(loginButton)
    }
    
    func setConstraints() {
        NSLayoutConstraint.activate([
            id.widthAnchor.constraint(equalToConstant: 285),
            id.heightAnchor.constraint(equalToConstant: 44),
            id.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            id.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 288)
        ])
        
        NSLayoutConstraint.activate([
            password.widthAnchor.constraint(equalToConstant: 285),
            password.heightAnchor.constraint(equalToConstant: 44),
            password.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            password.topAnchor.constraint(equalTo: id.bottomAnchor, constant: 30)
        ])
        
        NSLayoutConstraint.activate([
            loginButton.trailingAnchor.constraint(equalTo: password.trailingAnchor),
            loginButton.topAnchor.constraint(equalTo: password.bottomAnchor, constant: 27.5)
        ])
    }
    
    func bind() {
        let input = SejongLoginViewModelInput(
            loginButtonTapped: loginButtonTapped
        )
        
        let output = viewModel.transform(input: input)
    }
    
    func react() {
        loginButton.rx
            .tap
            .bind(onNext: { _ in
                self.loginButtonTapped.accept(
                    SejongLoginInfo(
                        id: self.id.text ?? "",
                        pw: self.password.text ?? ""
                    )
                )
            })
            .disposed(by: disposeBag)
    }
    
}
