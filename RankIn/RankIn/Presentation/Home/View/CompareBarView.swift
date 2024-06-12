//
//  CompareBarView.swift
//  RankIn
//
//  Created by 조성민 on 6/13/24.
//

import UIKit

final class CompareBarView: UIView {

    private var rate: Double? = nil
    private let bar: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemBlue
        
        return view
    }()
    
    init(scoreDiff: Double?) {
        if let scoreDiff = scoreDiff {
            self.rate = scoreDiff / 100.0
        }
        
        super.init(frame: .zero)
        setUp()
    }
    
    init(gradeDiff: Double?) {
        if let gradeDiff = gradeDiff {
            self.rate = gradeDiff / 4.5
        }
        
        super.init(frame: .zero)
        setUp()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUp() {
        self.backgroundColor = .systemGray4
        addSubview(bar)
        if let rate = rate {
            if rate < 0 {
                bar.backgroundColor = .systemRed
   
                NSLayoutConstraint.activate([
                    bar.topAnchor.constraint(equalTo: topAnchor),
                    bar.bottomAnchor.constraint(equalTo: bottomAnchor),
                    bar.leadingAnchor.constraint(equalTo: centerXAnchor, constant: 125 * rate),
                    bar.trailingAnchor.constraint(equalTo: centerXAnchor, constant: 0)
                ])
            } else {
                NSLayoutConstraint.activate([
                    bar.topAnchor.constraint(equalTo: topAnchor),
                    bar.bottomAnchor.constraint(equalTo: bottomAnchor),
                    bar.leadingAnchor.constraint(equalTo: centerXAnchor, constant: 0),
                    bar.trailingAnchor.constraint(equalTo: centerXAnchor, constant: 125 * rate)
                ])
            }
        }
        
    }
    
}
