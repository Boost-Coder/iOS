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
        let logout = UIAlertAction(title: "확인", style: .default) { _ in
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
        let logout = UIAlertAction(title: "탈퇴", style: .destructive) { _ in
            self.resignPublish.accept(())
        }
        let cancel = UIAlertAction(title: "취소", style: .cancel)
        
        alert.addAction(logout)
        alert.addAction(cancel)
        
        return alert
    }()
    
    private let informationView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemGray4
        view.layer.cornerRadius = 20
        
        return view
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .pretendard(type: .bold, size: 20)
        
        return label
    }()
    
    private let nicknameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .pretendard(type: .bold, size: 20)
        
        return label
    }()
    
    private let majorLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .pretendard(type: .regular, size: 18)
        
        return label
    }()
    
    private let studentNumberLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .pretendard(type: .regular, size: 14)
        
        return label
    }()
    
    private let statView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemGray4
        view.layer.cornerRadius = 20
        
        return view
    }()
    
    private let gitHubStatHeader: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .pretendard(type: .regular, size: 18)
        label.text = "GitHub"
        
        return label
    }()
    
    private let algorithmStatHeader: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .pretendard(type: .regular, size: 18)
        label.text = "알고리즘"
        
        return label
    }()
    
    private let gradeStatHeader: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .pretendard(type: .regular, size: 18)
        label.text = "학점"
        
        return label
    }()
    
    private let totalStatHeader: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .pretendard(type: .regular, size: 18)
        label.text = "종합"
        
        return label
    }()
    
    private let gitHubStatLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .pretendard(type: .bold, size: 18)
        
        return label
    }()
    
    private let algorithmStatLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .pretendard(type: .bold, size: 18)
        
        return label
    }()
    
    private let gradeStatLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .pretendard(type: .bold, size: 18)
        
        return label
    }()
    
    private let totalStatLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .pretendard(type: .bold, size: 18)
        
        return label
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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        viewDidLoadPublish.accept(())
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.statView.subviews.last?.removeFromSuperview()
        self.statView.subviews.last?.removeFromSuperview()
        self.statView.subviews.last?.removeFromSuperview()
        self.statView.subviews.last?.removeFromSuperview()
    }

}

private extension MyPageViewController {
    
    func setUI() {
        view.backgroundColor = .systemGray6
        navigationController?.navigationBar.barTintColor = .systemGray6
        navigationController?.navigationBar.isHidden = true
        
        setHierarchy()
        setConstraints()
    }
    
    func setHierarchy() {
        view.addSubview(informationView)
        informationView.addSubview(nameLabel)
        informationView.addSubview(nicknameLabel)
        informationView.addSubview(majorLabel)
        informationView.addSubview(studentNumberLabel)
        informationView.addSubview(logOutButton)
        informationView.addSubview(resignButton)
        
        view.addSubview(statView)
        statView.addSubview(gitHubStatHeader)
        statView.addSubview(gradeStatHeader)
        statView.addSubview(algorithmStatHeader)
        statView.addSubview(gitHubStatLabel)
        statView.addSubview(gradeStatLabel)
        statView.addSubview(algorithmStatLabel)
        statView.addSubview(totalStatHeader)
        statView.addSubview(totalStatLabel)
    }
    
    func setConstraints() {
        setInformationView()
        setStatView()
    }
    
    func setInformationView() {
        NSLayoutConstraint.activate([
            informationView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            informationView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25),
            informationView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25),
            informationView.heightAnchor.constraint(equalToConstant: 215)
        ])

        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: informationView.topAnchor, constant: 34),
            nameLabel.leadingAnchor.constraint(equalTo: informationView.leadingAnchor, constant: 47)
        ])
        
        NSLayoutConstraint.activate([
            nicknameLabel.topAnchor.constraint(equalTo: informationView.topAnchor, constant: 34),
            nicknameLabel.leadingAnchor.constraint(equalTo: nameLabel.trailingAnchor, constant: 10)
        ])
        
        NSLayoutConstraint.activate([
            majorLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 10),
            majorLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor, constant: 0)
        ])
        
        NSLayoutConstraint.activate([
            studentNumberLabel.topAnchor.constraint(equalTo: majorLabel.bottomAnchor, constant: 10),
            studentNumberLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor, constant: 0)
        ])
        
        NSLayoutConstraint.activate([
            logOutButton.bottomAnchor.constraint(equalTo: informationView.bottomAnchor, constant: -20),
            logOutButton.trailingAnchor.constraint(equalTo: informationView.centerXAnchor, constant: -20),
            logOutButton.widthAnchor.constraint(equalToConstant: 100),
            logOutButton.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        NSLayoutConstraint.activate([
            resignButton.bottomAnchor.constraint(equalTo: informationView.bottomAnchor, constant: -20),
            resignButton.leadingAnchor.constraint(equalTo: informationView.centerXAnchor, constant: 20),
            resignButton.widthAnchor.constraint(equalToConstant: 100),
            resignButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    func setStatView() {
        NSLayoutConstraint.activate([
            statView.topAnchor.constraint(equalTo: informationView.bottomAnchor, constant: 20),
            statView.leadingAnchor.constraint(equalTo: informationView.leadingAnchor),
            statView.trailingAnchor.constraint(equalTo: informationView.trailingAnchor),
            statView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10)
        ])
        
        NSLayoutConstraint.activate([
            totalStatHeader.topAnchor.constraint(equalTo: statView.topAnchor, constant: 20),
            totalStatHeader.leadingAnchor.constraint(equalTo: statView.leadingAnchor, constant: 25)
        ])
        
        NSLayoutConstraint.activate([
            totalStatLabel.topAnchor.constraint(equalTo: totalStatHeader.topAnchor, constant: 0),
            totalStatLabel.leadingAnchor.constraint(equalTo: totalStatHeader.trailingAnchor, constant: 10)
        ])
        
        NSLayoutConstraint.activate([
            algorithmStatHeader.topAnchor.constraint(equalTo: totalStatHeader.bottomAnchor, constant: 60),
            algorithmStatHeader.leadingAnchor.constraint(equalTo: statView.leadingAnchor, constant: 25)
        ])
        
        NSLayoutConstraint.activate([
            algorithmStatLabel.topAnchor.constraint(equalTo: algorithmStatHeader.topAnchor, constant: 0),
            algorithmStatLabel.leadingAnchor.constraint(equalTo: algorithmStatHeader.trailingAnchor, constant: 10)
        ])
        
        NSLayoutConstraint.activate([
            gitHubStatHeader.topAnchor.constraint(equalTo: algorithmStatHeader.bottomAnchor, constant: 60),
            gitHubStatHeader.leadingAnchor.constraint(equalTo: statView.leadingAnchor, constant: 25)
        ])
        
        NSLayoutConstraint.activate([
            gitHubStatLabel.topAnchor.constraint(equalTo: gitHubStatHeader.topAnchor, constant: 0),
            gitHubStatLabel.leadingAnchor.constraint(equalTo: gitHubStatHeader.trailingAnchor, constant: 10)
        ])
        
        NSLayoutConstraint.activate([
            gradeStatHeader.topAnchor.constraint(equalTo: gitHubStatHeader.bottomAnchor, constant: 60),
            gradeStatHeader.leadingAnchor.constraint(equalTo: statView.leadingAnchor, constant: 25)
        ])
        
        NSLayoutConstraint.activate([
            gradeStatLabel.topAnchor.constraint(equalTo: gradeStatHeader.topAnchor, constant: 0),
            gradeStatLabel.leadingAnchor.constraint(equalTo: gradeStatHeader.trailingAnchor, constant: 10)
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
            .subscribe(onNext: { information in
                self.nameLabel.text = information.name
                self.majorLabel.text = information.major
                self.studentNumberLabel.text = information.studentID
                self.nicknameLabel.text = "(\(information.nickname))"
            })
            .disposed(by: disposeBag)
        
        output.myStat
            .subscribe(onNext: { stat in
                self.gradeStatLabel.text = String(stat.grade)
                self.algorithmStatLabel.text = String(stat.algorithmPoint)
                self.gitHubStatLabel.text = String(stat.githubPoint)
                self.totalStatLabel.text = String(stat.totalPoint)
                self.drawStat(stat: stat)
            })
            .disposed(by: disposeBag)
    }
    
}

private extension MyPageViewController {
    
    func drawStat(stat: UserStat) {
        
        let gradeView = ScoreAnimationView(grade: stat.grade)
        let algorithmView = ScoreAnimationView(score: stat.algorithmPoint)
        let gitHubView = ScoreAnimationView(score: stat.githubPoint)
        let totalView = ScoreAnimationView(score: stat.totalPoint)
        
        gradeView.translatesAutoresizingMaskIntoConstraints = false
        algorithmView.translatesAutoresizingMaskIntoConstraints = false
        gitHubView.translatesAutoresizingMaskIntoConstraints = false
        totalView.translatesAutoresizingMaskIntoConstraints = false
        
        self.statView.addSubview(gradeView)
        self.statView.addSubview(algorithmView)
        self.statView.addSubview(gitHubView)
        self.statView.addSubview(totalView)
        
        NSLayoutConstraint.activate([
            gradeView.topAnchor.constraint(equalTo: gradeStatHeader.bottomAnchor, constant: 20),
            gradeView.leadingAnchor.constraint(equalTo: statView.leadingAnchor, constant: 47),
            gradeView.trailingAnchor.constraint(equalTo: statView.trailingAnchor, constant: -47),
            gradeView.heightAnchor.constraint(equalToConstant: 30)
        ])
        
        NSLayoutConstraint.activate([
            algorithmView.topAnchor.constraint(equalTo: algorithmStatHeader.bottomAnchor, constant: 20),
            algorithmView.leadingAnchor.constraint(equalTo: statView.leadingAnchor, constant: 47),
            algorithmView.trailingAnchor.constraint(equalTo: statView.trailingAnchor, constant: -47),
            algorithmView.heightAnchor.constraint(equalToConstant: 30)
        ])
        
        NSLayoutConstraint.activate([
            gitHubView.topAnchor.constraint(equalTo: gitHubStatHeader.bottomAnchor, constant: 20),
            gitHubView.leadingAnchor.constraint(equalTo: statView.leadingAnchor, constant: 47),
            gitHubView.trailingAnchor.constraint(equalTo: statView.trailingAnchor, constant: -47),
            gitHubView.heightAnchor.constraint(equalToConstant: 30)
        ])
        
        NSLayoutConstraint.activate([
            totalView.topAnchor.constraint(equalTo: totalStatHeader.bottomAnchor, constant: 20),
            totalView.leadingAnchor.constraint(equalTo: statView.leadingAnchor, constant: 47),
            totalView.trailingAnchor.constraint(equalTo: statView.trailingAnchor, constant: -47),
            totalView.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
    
}
