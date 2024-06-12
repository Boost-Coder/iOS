//
//  CompareViewController.swift
//  RankIn
//
//  Created by 조성민 on 6/12/24.
//

import UIKit
import RxSwift
import RxCocoa
import RxRelay

final class CompareViewController: UIViewController {
    
    private let disposeBag = DisposeBag()
    
    private let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .gray
        view.layer.opacity = 0.5
        
        return view
    }()
    
    private let compareView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemGray6
        view.layer.cornerRadius = 20
        view.clipsToBounds = true
        
        return view
    }()
    
    private lazy var closeButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(.init(systemName: "xmark"), for: .normal)
        button.tintColor = .systemGray3
        button.rx
            .tap
            .bind { _ in
                self.dismiss(animated: false)
            }
            .disposed(by: self.disposeBag)
        
        return button
    }()
    
    private let rankLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.font = .pretendard(type: .semiBold, size: 30)
        
        return label
    }()
    
    private let nickNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.font = .pretendard(type: .bold, size: 15)
        
        return label
    }()
    
    private let scoreLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.font = .pretendard(type: .regular, size: 13)
        
        return label
    }()
    
    private let divideView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .gray
        
        return view
    }()
    
    private let compareHeader: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.font = .pretendard(type: .semiBold, size: 18)
        label.text = "나와의 비교"
        
        return label
    }()
    
    private let gitHubStatHeader: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .pretendard(type: .regular, size: 13)
        label.text = "GitHub"
        
        return label
    }()
    
    private let algorithmStatHeader: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .pretendard(type: .regular, size: 15)
        label.text = "알고리즘"
        
        return label
    }()
    
    private let gradeStatHeader: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .pretendard(type: .regular, size: 15)
        label.text = "학점"
        
        return label
    }()
    
    private let totalStatHeader: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .pretendard(type: .regular, size: 15)
        label.text = "종합"
        
        return label
    }()
    
    private let totalBar: CompareBarView
    
    private let gradeBar: CompareBarView

    private let algorithmBar: CompareBarView

    private let gitHubBar: CompareBarView

    let diff: Versus
    
    init(
        content: CompareContents
    ) {
        self.diff = content.versus
        totalBar = CompareBarView(scoreDiff: content.versus.totalScoreDifference)
        gradeBar = CompareBarView(gradeDiff: content.versus.gradeScoreDifference)
        algorithmBar = CompareBarView(scoreDiff: content.versus.algorithmScoreDifference)
        gitHubBar = CompareBarView(scoreDiff: content.versus.githubScoreDifference)
        totalBar.translatesAutoresizingMaskIntoConstraints = false
        gradeBar.translatesAutoresizingMaskIntoConstraints = false
        algorithmBar.translatesAutoresizingMaskIntoConstraints = false
        gitHubBar.translatesAutoresizingMaskIntoConstraints = false
        
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .overFullScreen
        
        setContents(
            content: content
        )
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
    }

}

private extension CompareViewController {
    
    func setUI() {
        setHierarchy()
        setConstraints()
    }
    
    func setHierarchy() {
        view.addSubview(containerView)
        view.addSubview(compareView)
        compareView.addSubview(divideView)
        compareView.addSubview(closeButton)
        compareView.addSubview(rankLabel)
        compareView.addSubview(nickNameLabel)
        compareView.addSubview(scoreLabel)
        compareView.addSubview(compareHeader)
        compareView.addSubview(gradeStatHeader)
        compareView.addSubview(totalStatHeader)
        compareView.addSubview(algorithmStatHeader)
        compareView.addSubview(gitHubStatHeader)
        compareView.addSubview(gradeBar)
        compareView.addSubview(totalBar)
        compareView.addSubview(algorithmBar)
        compareView.addSubview(gitHubBar)
    }
    
    func setConstraints() {
        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            containerView.topAnchor.constraint(equalTo: view.topAnchor),
            containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            compareView.centerXAnchor.constraint(equalTo: containerView.safeAreaLayoutGuide.centerXAnchor),
            compareView.centerYAnchor.constraint(equalTo: containerView.safeAreaLayoutGuide.centerYAnchor),
            compareView.widthAnchor.constraint(equalToConstant: 300),
            compareView.heightAnchor.constraint(equalToConstant: 400)
        ])
        
        NSLayoutConstraint.activate([
            closeButton.topAnchor.constraint(equalTo: compareView.safeAreaLayoutGuide.topAnchor, constant: 10),
            closeButton.trailingAnchor.constraint(equalTo: compareView.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            closeButton.widthAnchor.constraint(equalToConstant: 20),
            closeButton.heightAnchor.constraint(equalToConstant: 20)
        ])
        
        NSLayoutConstraint.activate([
            rankLabel.topAnchor.constraint(equalTo: compareView.safeAreaLayoutGuide.topAnchor, constant: 40),
            rankLabel.leadingAnchor.constraint(equalTo: compareView.safeAreaLayoutGuide.leadingAnchor, constant: 30)
        ])
        
        NSLayoutConstraint.activate([
            nickNameLabel.centerYAnchor.constraint(equalTo: rankLabel.centerYAnchor, constant: 0),
            nickNameLabel.leadingAnchor.constraint(equalTo: rankLabel.trailingAnchor, constant: 20)
        ])
        
        NSLayoutConstraint.activate([
            scoreLabel.centerYAnchor.constraint(equalTo: rankLabel.centerYAnchor),
            scoreLabel.trailingAnchor.constraint(equalTo: compareView.safeAreaLayoutGuide.trailingAnchor, constant: -30)
        ])
        
        NSLayoutConstraint.activate([
            divideView.topAnchor.constraint(equalTo: rankLabel.bottomAnchor, constant: 10),
            divideView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            divideView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            divideView.heightAnchor.constraint(equalToConstant: 0.5)
        ])
        
        NSLayoutConstraint.activate([
            compareHeader.topAnchor.constraint(equalTo: divideView.bottomAnchor, constant: 10),
            compareHeader.leadingAnchor.constraint(equalTo: compareView.safeAreaLayoutGuide.leadingAnchor, constant: 20)
        ])
        
        NSLayoutConstraint.activate([
            totalStatHeader.topAnchor.constraint(equalTo: compareHeader.bottomAnchor, constant: 15),
            totalStatHeader.leadingAnchor.constraint(equalTo: compareView.leadingAnchor, constant: 25)
        ])
        
        NSLayoutConstraint.activate([
            totalBar.topAnchor.constraint(equalTo: totalStatHeader.bottomAnchor, constant: 10),
            totalBar.leadingAnchor.constraint(equalTo: compareView.leadingAnchor, constant: 25),
            totalBar.trailingAnchor.constraint(equalTo: compareView.trailingAnchor, constant: -25),
            totalBar.heightAnchor.constraint(equalToConstant: 20)
        ])
        
        NSLayoutConstraint.activate([
            algorithmStatHeader.topAnchor.constraint(equalTo: totalBar.bottomAnchor, constant: 10),
            algorithmStatHeader.leadingAnchor.constraint(equalTo: compareView.leadingAnchor, constant: 25)
        ])
        
        NSLayoutConstraint.activate([
            algorithmBar.topAnchor.constraint(equalTo: algorithmStatHeader.bottomAnchor, constant: 10),
            algorithmBar.leadingAnchor.constraint(equalTo: compareView.leadingAnchor, constant: 25),
            algorithmBar.trailingAnchor.constraint(equalTo: compareView.trailingAnchor, constant: -25),
            algorithmBar.heightAnchor.constraint(equalToConstant: 20)
        ])
        
        NSLayoutConstraint.activate([
            gitHubStatHeader.topAnchor.constraint(equalTo: algorithmBar.bottomAnchor, constant: 15),
            gitHubStatHeader.leadingAnchor.constraint(equalTo: compareView.leadingAnchor, constant: 25)
        ])
        
        NSLayoutConstraint.activate([
            gitHubBar.topAnchor.constraint(equalTo: gitHubStatHeader.bottomAnchor, constant: 10),
            gitHubBar.leadingAnchor.constraint(equalTo: compareView.leadingAnchor, constant: 25),
            gitHubBar.trailingAnchor.constraint(equalTo: compareView.trailingAnchor, constant: -25),
            gitHubBar.heightAnchor.constraint(equalToConstant: 20)
        ])
        
        NSLayoutConstraint.activate([
            gradeStatHeader.topAnchor.constraint(equalTo: gitHubBar.bottomAnchor, constant: 15),
            gradeStatHeader.leadingAnchor.constraint(equalTo: compareView.leadingAnchor, constant: 25)
        ])
        
        NSLayoutConstraint.activate([
            gradeBar.topAnchor.constraint(equalTo: gradeStatHeader.bottomAnchor, constant: 10),
            gradeBar.leadingAnchor.constraint(equalTo: compareView.leadingAnchor, constant: 25),
            gradeBar.trailingAnchor.constraint(equalTo: compareView.trailingAnchor, constant: -25),
            gradeBar.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
    
    func setContents(
        content: CompareContents
    ) {
        self.nickNameLabel.text = content.content.nickName
        self.rankLabel.text = String(content.content.rank)
        self.scoreLabel.text = String(content.content.score)
        
        if let total = content.versus.totalScoreDifference {
            totalStatHeader.text = totalStatHeader.text! + "  " + String(total)
        } else {
            totalStatHeader.text = totalStatHeader.text! + "  미등록"
        }
        if let grade = content.versus.gradeScoreDifference {
            gradeStatHeader.text = gradeStatHeader.text! + "  " + String(grade)
        } else {
            gradeStatHeader.text = gradeStatHeader.text! + "  미등록"
        }
        if let github = content.versus.githubScoreDifference {
            gitHubStatHeader.text = gitHubStatHeader.text! + "  " + String(github)
        } else {
            gitHubStatHeader.text = gitHubStatHeader.text! + "  미등록"
        }
        if let algorithm = content.versus.algorithmScoreDifference {
            algorithmStatHeader.text = algorithmStatHeader.text! + "  " + String(algorithm)
        } else {
            algorithmStatHeader.text = algorithmStatHeader.text! + "  미등록"
        }
        
    }
    
}
