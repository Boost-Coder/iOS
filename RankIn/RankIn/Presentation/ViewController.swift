//
//  ViewController.swift
//  RankIn
//
//  Created by 조성민 on 3/21/24.
//

import UIKit

final class ViewController: UIViewController {
    
    init() {
        super.init(nibName: nil, bundle: nil)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBlue
    }

}
