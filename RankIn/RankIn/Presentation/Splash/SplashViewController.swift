//
//  SplashViewController.swift
//  RankIn
//
//  Created by 조성민 on 3/21/24.
//

import UIKit

final class SplashViewController: UIViewController {
    
    private let loginViewController: LoginViewController
    
    private let labelImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage.rankIn)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    init(loginViewController: LoginViewController) {
        self.loginViewController = loginViewController
        
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
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.view.subviews.forEach({ $0.removeFromSuperview() })
                self.present(self.loginViewController, animated: true)
            }
        }
    }
    
    func splashAnimate(completion: @escaping () -> Void) {
        let animationView = SplashAnimationView(
            animationMinX: labelImageView.frame.minX - 15,
            animationMaxX: labelImageView.frame.maxX + 15,
            centerY: view.center.y,
            completion: completion,
            animation: true
        )
        animationView.frame = CGRect(
            x: 0, y: 0, 
            width: view.frame.width,
            height: view.frame.height
        )
        view.addSubview(animationView)
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
