//
//  GradeViewController.swift
//  RankIn
//
//  Created by 조성민 on 4/17/24.
//

import UIKit
import RxSwift
import RxRelay

final class GradeViewController: UIViewController {
    
    private let disposeBag = DisposeBag()
    
    // MARK: Input
    private let nextButtonTapped = PublishRelay<String>()
    
    private let grade: UITextField = {
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
            string: "학점",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemGray]
        )
        
        return textField
    }()
    
    private let nextButton: UIButton = {
        var attributeTitle = AttributedString("등록")
        attributeTitle.font = UIFont.pretendard(type: .semiBold, size: 17)
        
        var configuration = UIButton.Configuration.filled()
        configuration.attributedTitle = attributeTitle
        configuration.baseBackgroundColor = .systemBlue
        
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
    
    private lazy var indicatorView: UIActivityIndicatorView = {
        let indicatorView = UIActivityIndicatorView()
        indicatorView.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        indicatorView.center = view.center
        indicatorView.style = .large
        indicatorView.color = .sejongPrimary
        
        return indicatorView
    }()
    
    private let viewModel: GradeViewModel
    private let gitHubViewController: GitHubViewController
    
    init(
        gradeViewModel: GradeViewModel,
        gitHubViewController: GitHubViewController
    ) {
        self.viewModel = gradeViewModel
        self.gitHubViewController = gitHubViewController
        
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

private extension GradeViewController {
    
    func setUI() {
        view.backgroundColor = .systemGray6
        
        setHierarchy()
        setConstraints()
    }
    
    func setHierarchy() {
        view.addSubview(grade)
        view.addSubview(nextButton)
        view.addSubview(skipButton)
        view.addSubview(indicatorView)
    }
    
    func setConstraints() {
        NSLayoutConstraint.activate([
            grade.widthAnchor.constraint(equalToConstant: 285),
            grade.heightAnchor.constraint(equalToConstant: 44),
            grade.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            grade.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 258)
        ])
        
        NSLayoutConstraint.activate([
            nextButton.trailingAnchor.constraint(equalTo: grade.trailingAnchor),
            nextButton.topAnchor.constraint(equalTo: grade.bottomAnchor, constant: 17.5)
        ])
        
        NSLayoutConstraint.activate([
            skipButton.centerXAnchor.constraint(equalTo: grade.centerXAnchor),
            skipButton.topAnchor.constraint(equalTo: nextButton.bottomAnchor, constant: 5)
        ])
    }
    
    func bind() {
        let input = GradeViewModelInput(nextButtonTapped: nextButtonTapped)
        
        let output = viewModel.transform(input: input)
        
        output.gradeSuccess
            .subscribe { _ in
                self.navigationController?.pushViewController(
                    self.gitHubViewController, animated: false
                )
                self.controlIndicator(isEnable: false)
            } onError: { error in
                dump(error)
                self.controlIndicator(isEnable: false)
            }
            .disposed(by: disposeBag)
        
        output.gradeFailure
            .subscribe { _ in
                self.presentToast(toastCase: .invalidGradeInput)
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
                guard let gradeText = self.grade.text else {
                    self.presentToast(toastCase: .noGradeInput)
                    self.controlIndicator(isEnable: false)
                    return
                }
                self.controlIndicator(isEnable: true)
                self.nextButtonTapped.accept(gradeText)
            })
            .disposed(by: disposeBag)
        
        skipButton.rx
            .tap
            .bind { _ in
                self.navigationController?.pushViewController(
                    self.gitHubViewController, animated: false
                )
                self.controlIndicator(isEnable: false)
            }
            .disposed(by: disposeBag)
    }
    
}
