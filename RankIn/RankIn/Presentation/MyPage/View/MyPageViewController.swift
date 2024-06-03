//
//  MyPageViewController.swift
//  RankIn
//
//  Created by 조성민 on 4/6/24.
//

import UIKit

final class MyPageViewController: UIViewController {

    private lazy var logOutButton: UIButton = {
        var attributedString = AttributedString("로그아웃")
        attributedString.font = UIFont.pretendard(type: .bold, size: 16)
        
        var configuration = UIButton.Configuration.filled()
        configuration.attributedTitle = attributedString
        configuration.baseForegroundColor = .black
        configuration.baseBackgroundColor = .white
        
        let button = UIButton(configuration: configuration)
        button.translatesAutoresizingMaskIntoConstraints = false
        
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
        
        return button
    }()
    
    init() {
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
    }
    
}
