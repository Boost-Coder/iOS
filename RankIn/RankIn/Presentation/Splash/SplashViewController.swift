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
        let animationView = SplashAnimationView(
            animationMinX: 10,
            animationMaxX: view.frame.maxX - 10,
            centerY: view.center.y,
            completion: completion
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
