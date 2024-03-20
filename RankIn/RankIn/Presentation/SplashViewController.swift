//
//  SplashViewController.swift
//  RankIn
//
//  Created by 조성민 on 3/21/24.
//

import UIKit

final class SplashViewController: UIViewController {
    
    private let homeViewController: HomeViewController
    
    private let labelImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage.rankIn)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    init(homeViewController: HomeViewController) {
        self.homeViewController = homeViewController
        
        super.init(nibName: nil, bundle: nil)
        self.modalPresentationStyle = .fullScreen
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        splashAnimate {
            DispatchQueue.main.async {
                self.present(self.homeViewController, animated: false)
            }
        }
    }
    
    func splashAnimate(completion: @escaping () -> Void) {
        // TODO: 스플레시 애니메이션 구현
        
        completion()
    }

}

private extension SplashViewController {
    
    func setUI() {
        view.backgroundColor = .systemGray6
        
        setHierarchy()
        setConstraints()
    }
    
    func setHierarchy() {
        view.addSubview(labelImageView)
    }
    
    func setConstraints() {
        NSLayoutConstraint.activate([
            labelImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            labelImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -20)
        ])
    }
    
}
