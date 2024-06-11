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
        let backBarPath = UIBezierPath()
        backBarPath.move(to: rect.origin)
        backBarPath.addLine(to: CGPoint(x: rect.origin.x + bounds.width, y: rect.origin.y))
        
        let backBarLayer = CAShapeLayer()
        backBarLayer.frame = bounds
        backBarLayer.path = backBarPath.cgPath
        backBarLayer.strokeColor = UIColor.systemGray3.cgColor
        backBarLayer.lineWidth = 30
        self.layer.addSublayer(backBarLayer)
        
        let backBarAnimation = CABasicAnimation(keyPath: "strokeEnd")
        backBarAnimation.fromValue = 0
        backBarAnimation.toValue = 1
        backBarAnimation.timingFunction = CAMediaTimingFunction(name: .easeIn)
        backBarAnimation.fillMode = .forwards
        backBarAnimation.isRemovedOnCompletion = false
        
        backBarLayer.add(backBarAnimation, forKey: "line")
        
        let path = UIBezierPath()
        path.move(to: rect.origin)
        path.addLine(to: CGPoint(x: rect.origin.x + rate * bounds.width, y: rect.origin.y))
        
        let lineLayer = CAShapeLayer()
        lineLayer.frame = bounds
        lineLayer.path = path.cgPath
        lineLayer.strokeColor = UIColor.sejongPrimary.cgColor
        lineLayer.lineWidth = 30
        self.layer.addSublayer(lineLayer)
        
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.fromValue = 0
        animation.toValue = 1
        animation.duration = 2
        animation.timingFunction = CAMediaTimingFunction(name: .easeIn)
        animation.fillMode = .forwards
        animation.isRemovedOnCompletion = false
        
        lineLayer.add(animation, forKey: "line")
    }
    
}
