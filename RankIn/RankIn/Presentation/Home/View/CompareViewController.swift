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
    
    init(
        content: CompareContents
    ) {
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
        compareView.addSubview(closeButton)
        compareView.addSubview(rankLabel)
        compareView.addSubview(nickNameLabel)
        compareView.addSubview(scoreLabel)
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
    }
    
    func setContents(
        content: CompareContents
    ) {
        self.nickNameLabel.text = content.content.nickName
        self.rankLabel.text = String(content.content.rank)
        self.scoreLabel.text = String(content.content.score)
    }
    
}
