//
//  BaekjoonViewController.swift
//  RankIn
//
//  Created by 조성민 on 5/12/24.
//

import UIKit
import RxSwift
import RxRelay

final class BaekjoonViewController: UIViewController {
    
    private let disposeBag = DisposeBag()
    
    // MARK: Input
    private let nextButtonTapped = PublishRelay<String>()
    
    private let baekjoonID: UITextField = {
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
            string: "백준 아이디",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemGray]
        )
        
        return textField
    }()
    
    private let nextButton: UIButton = {
        var attributeTitle = AttributedString("등록")
        attributeTitle.font = UIFont.pretendard(type: .semiBold, size: 17)
        
        var configuration = UIButton.Configuration.filled()
        configuration.attributedTitle = attributeTitle
        configuration.baseBackgroundColor = .systemGray
        
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
    
    private let viewModel: BaekjoonViewModel
    private let mainTabBarController: UITabBarController
    
    init(
        baekjoonViewModel: BaekjoonViewModel,
        mainTabBarController: UITabBarController
    ) {
        self.viewModel = baekjoonViewModel
        self.mainTabBarController = mainTabBarController
        
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

private extension BaekjoonViewController {
    
    func setUI() {
        view.backgroundColor = .systemGray6
        
        setHierarchy()
        setConstraints()
    }
    
    func setHierarchy() {
        view.addSubview(baekjoonID)
        view.addSubview(nextButton)
        view.addSubview(skipButton)
    }
    
    func setConstraints() {
        NSLayoutConstraint.activate([
            baekjoonID.widthAnchor.constraint(equalToConstant: 285),
            baekjoonID.heightAnchor.constraint(equalToConstant: 44),
            baekjoonID.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            baekjoonID.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 258)
        ])
        
        NSLayoutConstraint.activate([
            nextButton.trailingAnchor.constraint(equalTo: baekjoonID.trailingAnchor),
            nextButton.topAnchor.constraint(equalTo: baekjoonID.bottomAnchor, constant: 17.5)
        ])
        
        NSLayoutConstraint.activate([
            skipButton.centerXAnchor.constraint(equalTo: baekjoonID.centerXAnchor),
            skipButton.topAnchor.constraint(equalTo: nextButton.bottomAnchor, constant: 5)
        ])
    }
    
    func bind() {
        let input = BaekjoonViewModelInput(nextButtonTapped: nextButtonTapped)
        
        let output = viewModel.transform(input: input)
        
        output.baekjoonSuccess
            .subscribe { _ in
                self.navigationController?.pushViewController(
                    self.mainTabBarController, animated: true
                )
            } onError: { error in
                dump(error)
            }
            .disposed(by: disposeBag)
        
        output.baekjoonFailure
            .subscribe { _ in
                self.presentToast(toastCase: .invalidGradeInput)
            } onError: { error in
                dump(error)
            }
            .disposed(by: disposeBag)
        
        output.errorPublisher
            .bind { error in
                self.presentErrorToast(error: error)
            }
            .disposed(by: disposeBag)
    }
    
    func react() {
        nextButton.rx
            .tap
            .bind(onNext: { _ in
                guard let baekjoonIDText = self.baekjoonID.text else {
                    self.presentToast(toastCase: .noGradeInput)
                    return
                }
                self.nextButtonTapped.accept(baekjoonIDText)
            })
            .disposed(by: disposeBag)
        
        skipButton.rx
            .tap
            .bind { _ in
                self.navigationController?.pushViewController(
                    self.mainTabBarController, animated: true
                )
            }
            .disposed(by: disposeBag)
    }
    
}
