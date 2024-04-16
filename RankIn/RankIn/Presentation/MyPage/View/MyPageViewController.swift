//
//  MyPageViewController.swift
//  RankIn
//
//  Created by 조성민 on 4/6/24.
//

import UIKit

final class MyPageViewController: UIViewController {

    init() {
        super.init(nibName: nil, bundle: nil)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .sejongPrimary
    }

}
