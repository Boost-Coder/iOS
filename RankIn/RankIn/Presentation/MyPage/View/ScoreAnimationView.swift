//
//  ScoreAnimationView.swift
//  RankIn
//
//  Created by 조성민 on 6/11/24.
//

import UIKit

final class ScoreAnimationView: UIView {
    
    private let rate: Double
    
    init(score: Double) {
        self.rate = score / 100.0
        
        super.init(frame: .zero)
    }
    
    init(grade: Double) {
        self.rate = grade / 4.5
        
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        let path = UIBezierPath()
        path.move(to: rect.origin)
        path.addLine(to: CGPoint(x: rect.origin.x + rate * bounds.width, y: rect.origin.y))
        
        let lineLayer = CAShapeLayer()
        lineLayer.frame = bounds
        lineLayer.path = path.cgPath
        lineLayer.strokeColor = UIColor.sejongPrimary.cgColor
        lineLayer.lineWidth = 3
        self.layer.addSublayer(lineLayer)
        CATransaction.begin()
        
        let animation = CABasicAnimation()
        animation.fromValue = 0
        animation.toValue = 1
        animation.duration = 0.5
        animation.timingFunction = CAMediaTimingFunction(name: .easeIn)
        animation.fillMode = .forwards
        
        lineLayer.add(animation, forKey: nil)
        
        CATransaction.commit()
    }
    
}
