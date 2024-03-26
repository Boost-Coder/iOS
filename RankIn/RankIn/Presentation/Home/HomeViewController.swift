//
//  HomeViewController.swift
//  RankIn
//
//  Created by 조성민 on 3/21/24.
//

import UIKit

final class HomeViewController: UIViewController {
    
    init() {
        super.init(nibName: nil, bundle: nil)
        
        self.modalPresentationStyle = .fullScreen
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemPink
    }

}
