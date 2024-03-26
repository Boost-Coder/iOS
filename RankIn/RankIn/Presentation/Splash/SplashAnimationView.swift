//
//  SplashAnimationView.swift
//  RankIn
//
//  Created by 조성민 on 3/22/24.
//

import UIKit
import RxSwift
import RxRelay

final class SplashAnimationView: UIView {
    
    private let animationMinX: CGFloat
    private let animationMaxX: CGFloat
    private let centerY: CGFloat
    private let completion: () -> Void
    private let animationSubject = PublishRelay<Void>()
    private let disposeBag = DisposeBag()
    
    init(
        animationMinX: CGFloat,
        animationMaxX: CGFloat,
        centerY: CGFloat,
        completion: @escaping () -> Void
    ) {
        self.animationMinX = animationMinX
        self.animationMaxX = animationMaxX
        self.centerY = centerY
        self.completion = completion
        
        super.init(frame: .zero)
        self.bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        CATransaction.begin()
        CATransaction.setCompletionBlock { [weak self] in
            self?.animationSubject.accept(())
        }
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
        leftLineLayer.strokeColor = UIColor.sejongPrimary.cgColor
        leftLineLayer.lineWidth = 3
        self.layer.addSublayer(leftLineLayer)
        let rightLineLayer = CAShapeLayer()
        rightLineLayer.frame = bounds
        rightLineLayer.path = rightPath.cgPath
        rightLineLayer.strokeColor = UIColor.sejongPrimary.cgColor
        rightLineLayer.lineWidth = 3
        self.layer.addSublayer(rightLineLayer)

        let firstAnimation = CABasicAnimation(keyPath: "strokeEnd")
        firstAnimation.fromValue = 0
        firstAnimation.toValue = 0.5
        firstAnimation.duration = 0.6
        firstAnimation.timingFunction = CAMediaTimingFunction(name: .easeOut)
        
        let secondAnimation = CABasicAnimation(keyPath: "strokeEnd")
        secondAnimation.fromValue = 0.5
        secondAnimation.toValue = 0.4
        secondAnimation.beginTime = 0.6
        secondAnimation.duration = 0.5
        secondAnimation.isRemovedOnCompletion = false
        secondAnimation.fillMode = .forwards
        secondAnimation.timingFunction = CAMediaTimingFunction(name: .easeIn)
        
        let animationGroup = CAAnimationGroup()
        animationGroup.duration = 1.6
        animationGroup.animations = [firstAnimation, secondAnimation]
        
        leftLineLayer.add(animationGroup, forKey: nil)
        rightLineLayer.add(animationGroup, forKey: nil)
        
        CATransaction.commit()
    }
    
    private func bind() {
        animationSubject
            .asObservable()
            .throttle(.seconds(2), latest: false, scheduler: MainScheduler())
            .subscribe(onNext: { [weak self] in
                self?.completion()
            })
            .disposed(by: disposeBag)
    }
    
}
