//
//  SegmentView.swift
//  Stories
//
//  Created by Aswin Babu on 3/21/18.
//  Copyright © 2018 Thahir Maheen. All rights reserved.
//


import UIKit

public typealias FinishHandler = (_ back: Bool) -> ()

public protocol ProgressBarDelegate: class {
    func progressBarFinished(finishedItem shouldGoBack:Bool)
}

public protocol ProgressBarElementViewDelegate: class {
    
    func progressBar(didFinishWithElement element: SegmentView, isBack:Bool)
    
}

public class SegmentView: UIView {
    
    weak var delegate: ProgressBarElementViewDelegate?
    let item: ProgressItem
    var isSkipping = false
    var progressTintColor: UIColor?
    var trackTintColor: UIColor?
    var filledShape = CAShapeLayer()
    
    public init(withItem item: ProgressItem!) {
        self.item = item
        super.init(frame: .zero)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Redraw the layer to show the unfilled segment
    func drawEmpty() {
        filledShape.removeAllAnimations()
        self.layer.sublayers?.forEach { $0.removeFromSuperlayer() }
        
        let emptyColor = trackTintColor ?? .lightGray
        let emptyShape = CAShapeLayer()
        emptyShape.frame = self.bounds
        emptyShape.backgroundColor = emptyColor.cgColor
        emptyShape.cornerRadius = bounds.height / 2
        self.layer.addSublayer(emptyShape)
    }
    
    // Redraw the layer to show the filled segment
    func drawLayer() {
        self.layer.sublayers?.forEach { $0.removeFromSuperlayer() }
        
        let fillColor = progressTintColor ?? .lightGray
        let fillShape = CAShapeLayer()
        fillShape.frame = self.bounds
        fillShape.backgroundColor = fillColor.cgColor
        fillShape.cornerRadius = bounds.height / 2
        self.layer.addSublayer(fillShape)
    }
    
    func animate(with duration: Double) {
        
        let fillColor = progressTintColor ?? .gray
        
        let startPath = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: bounds.height, height: bounds.height), cornerRadius: bounds.height / 2).cgPath
        let endPath = UIBezierPath(roundedRect: bounds, cornerRadius: bounds.height / 2)
        
        filledShape.removeFromSuperlayer()
        filledShape = CAShapeLayer()
        filledShape.path = startPath
        filledShape.fillColor = fillColor.cgColor
        self.layer.addSublayer(filledShape)
        
        CATransaction.begin()
        CATransaction.setCompletionBlock({
            self.finish()
            self.item.handler?()
        })
        
        let animation = CABasicAnimation(keyPath: "path")
        animation.toValue = endPath.cgPath
        animation.duration = duration
        animation.repeatCount = 1
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        animation.fillMode = kCAFillModeBoth
        animation.isRemovedOnCompletion = false
        
        filledShape.add(animation, forKey: animation.keyPath)
        CATransaction.commit()
    }
    
    // Play the progress of segment
    public func play() {
        filledShape.removeAllAnimations()
        drawEmpty()
        isSkipping = false
        animate(with: item.duration)
    }
    
    // Called to break current progress and switch to previous segment
    public func back() {
        isSkipping = true
        drawEmpty()
        finish(isBack: true)
    }
    
    // Called to break current progress and switch to next segment
    public func next() {
        isSkipping = true
        drawEmpty()
        drawLayer()
        finish()
    }
    
    // Called when current progress finishes
    private func finish(isBack: Bool = false) {
        // Only need to call delegate if its normal else discarded
        if !isSkipping {
            self.delegate?.progressBar(didFinishWithElement: self, isBack: isBack)
        }
    }
    
    var isPaused: Bool = false {
        didSet {
            
            if isPaused {
                let layer = filledShape
                let pausedTime = layer.convertTime(CACurrentMediaTime(), from: nil)
                layer.speed = 0.0
                layer.timeOffset = pausedTime
            } else {
                let layer = filledShape
                let pausedTime = layer.timeOffset
                layer.speed = 1.0
                layer.timeOffset = 0.0
                layer.beginTime = 0.0
                let timeSincePause = layer.convertTime(CACurrentMediaTime(), from: nil) - pausedTime
                layer.beginTime = timeSincePause
                
            }
        }
    }
}
