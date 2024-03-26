//
//  SplashAnimationView.swift
//  RankIn
//
//  Created by 조성민 on 3/22/24.
//

import UIKit

final class SplashAnimationView: UIView {
    
    let animationMinX: CGFloat
    let animationMaxX: CGFloat
    let centerY: CGFloat
    
    init(
        animationMinX: CGFloat,
        animationMaxX: CGFloat,
        centerY: CGFloat
    ) {
        self.animationMinX = animationMinX
        self.animationMaxX = animationMaxX
        self.centerY = centerY
        
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        let y = centerY + 5
        
        let leftPath = UIBezierPath()
        leftPath.move(to: CGPoint(
            x: (animationMinX + animationMaxX)/2.0,
            y: y
        ))
        leftPath.addLine(to: CGPoint(
            x: animationMinX,
            y: y
        ))
        
        let rightPath = UIBezierPath()
        rightPath.move(to: CGPoint(
            x: (animationMinX + animationMaxX)/2.0,
            y: y
        ))
        rightPath.addLine(to: CGPoint(
            x: animationMaxX,
            y: y
        ))
        
        let leftLineLayer = CAShapeLayer()
        leftLineLayer.frame = bounds
        leftLineLayer.path = leftPath.cgPath
        leftLineLayer.strokeColor = UIColor.primary.cgColor
        leftLineLayer.lineWidth = 3
        self.layer.addSublayer(leftLineLayer)
        let rightLineLayer = CAShapeLayer()
        rightLineLayer.frame = bounds
        rightLineLayer.path = rightPath.cgPath
        rightLineLayer.strokeColor = UIColor.primary.cgColor
        rightLineLayer.lineWidth = 3
        self.layer.addSublayer(rightLineLayer)

        let firstAnimation = CABasicAnimation(keyPath: "strokeEnd")
        firstAnimation.fromValue = 0
        firstAnimation.toValue = 0.5
        firstAnimation.duration = 0.7
        
        let secondAnimation = CABasicAnimation(keyPath: "strokeEnd")
        secondAnimation.fromValue = 0.5
        secondAnimation.toValue = 0.4
        secondAnimation.beginTime = 0.7
        secondAnimation.duration = 0.3
        
        let animationGroup = CAAnimationGroup()
        animationGroup.duration = 1 // 총 애니메이션 시간
        animationGroup.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        
        animationGroup.animations = [firstAnimation, secondAnimation]
        animationGroup.isRemovedOnCompletion = false
        animationGroup.fillMode = .both
        
        leftLineLayer.add(animationGroup, forKey: nil)
        rightLineLayer.add(animationGroup, forKey: nil)
    }
    
}
