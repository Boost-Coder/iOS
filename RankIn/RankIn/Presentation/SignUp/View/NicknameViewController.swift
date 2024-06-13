//
//  NicknameViewController.swift
//  RankIn
//
//  Created by 조성민 on 4/13/24.
//

import UIKit
import RxSwift
import RxRelay

final class NicknameViewController: UIViewController {
    
    private let disposeBag = DisposeBag()
    
    // MARK: Input
    private let nextButtonTapped = PublishRelay<String>()
    
    private let nickname: UITextField = {
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
            string: "닉네임",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemGray]
        )
        textField.autocapitalizationType = .none
        
        return textField
    }()
    
    private let nextButton: UIButton = {
        var attributeTitle = AttributedString("다음")
        attributeTitle.font = UIFont.pretendard(type: .semiBold, size: 17)
        
        var configuration = UIButton.Configuration.filled()
        configuration.attributedTitle = attributeTitle
        configuration.baseBackgroundColor = .systemGray
        
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.configuration = configuration
        
        return button
    }()
    
    private lazy var indicatorView: UIActivityIndicatorView = {
        let indicatorView = UIActivityIndicatorView()
        indicatorView.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        indicatorView.center = view.center
        indicatorView.style = .large
        indicatorView.color = .sejongPrimary
        
        return indicatorView
    }()
    
    private let viewModel: NicknameViewModel
    private let gradeViewController: GradeViewController
    
    init(
        nicknameViewModel: NicknameViewModel,
        gradeViewController: GradeViewController
    ) {
        self.viewModel = nicknameViewModel
        self.gradeViewController = gradeViewController
        
        super.init(nibName: nil, bundle: nil)
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        self.navigationItem.hidesBackButton = true
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

private extension NicknameViewController {
    
    func setUI() {
        view.backgroundColor = .systemGray6
        
        setHierarchy()
        setConstraints()
    }
    
    func setHierarchy() {
        view.addSubview(nickname)
        view.addSubview(nextButton)
        view.addSubview(indicatorView)
    }
    
    func setConstraints() {
        NSLayoutConstraint.activate([
            nickname.widthAnchor.constraint(equalToConstant: 285),
            nickname.heightAnchor.constraint(equalToConstant: 44),
            nickname.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            nickname.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 258)
        ])
        
        NSLayoutConstraint.activate([
            nextButton.trailingAnchor.constraint(equalTo: nickname.trailingAnchor),
            nextButton.topAnchor.constraint(equalTo: nickname.bottomAnchor, constant: 17.5)
        ])
    }
    
    func bind() {
        let input = NicknameViewModelInput(nextButtonTapped: nextButtonTapped)
        
        let output = viewModel.transform(input: input)
        
        output.nicknameSuccess
            .subscribe { _ in
                self.navigationController?.pushViewController(self.gradeViewController, animated: false)
                self.controlIndicator(isEnable: false)
            } onError: { error in
                dump(error)
                self.controlIndicator(isEnable: false)
            }
            .disposed(by: disposeBag)
        
        output.nicknameFailure
            .subscribe { _ in
                self.presentToast(toastCase: .duplicatedNickname)
                self.controlIndicator(isEnable: false)
            } onError: { error in
                dump(error)
                self.controlIndicator(isEnable: false)
            }
            .disposed(by: disposeBag)
        
        output.errorPublisher
            .bind { error in
                self.presentErrorToast(error: error)
                self.controlIndicator(isEnable: false)
            }
            .disposed(by: disposeBag)
    }
    
    func controlIndicator(isEnable: Bool) {
        if isEnable {
            indicatorView.startAnimating()
            view.isUserInteractionEnabled = false
        } else {
            indicatorView.stopAnimating()
            view.isUserInteractionEnabled = true
        }
    }
    
    func react() {
        nextButton.rx
            .tap
            .bind(onNext: { _ in
                if let nicknameText = self.nickname.text,
                   !nicknameText.isEmpty {            self.nextButtonTapped.accept(nicknameText)
                    self.controlIndicator(isEnable: true)
                } else {
                    self.presentToast(toastCase: .noNicknameInput)
                    self.controlIndicator(isEnable: false)
                    return
                }
            })
            .disposed(by: disposeBag)
    }
    
}
