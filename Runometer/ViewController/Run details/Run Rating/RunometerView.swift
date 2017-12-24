//
//  RunometerView.swift
//  Runometer
//
//  Created by Svante Dahlberg on 2017-11-25.
//  Copyright © 2017 Svante Dahlberg. All rights reserved.
//

import UIKit

@IBDesignable class RunometerView: UIView {
    
    // MARK: Public properties
    
    @IBInspectable let arcWidth: CGFloat = 30
    @IBInspectable let fillArcWidth: CGFloat = 20
    @IBInspectable let backgroundShapeColor: UIColor = .darkGray
    @IBInspectable let gradientStartColor: UIColor = .red
    @IBInspectable let gradientMiddleColor: UIColor = .yellow
    @IBInspectable let gradientEndColor: UIColor = .green
    
    /// The percentage to fill the meter with, represented by a number between 0 and 1.
    var percentage: CGFloat = 0 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    // MARK: Draw
    
    override func draw(_ rect: CGRect) {
        layer.addSublayer(gradientLayer)
        backgroundPath.stroke()
        maskShape.add(drawAnimation, forKey: nil)
        gradientLayer.mask = maskShape
    }
    
    // MARK: Private properties
    
    private lazy var arcCenter: CGPoint = {
        return CGPoint(x: bounds.width / 2, y: bounds.height / 2)
    }()
    
    private lazy var radius: CGFloat = {
        return max(bounds.width, bounds.height)
    }()
    
    private lazy var backgroundStartAngle: CGFloat = {
        return 3 * .pi / 4 + 0.15
    }()

    private lazy var backgroundEndAngle: CGFloat = {
        return .pi / 4 - 0.15
    }()
    
    private lazy var fillStartAngle: CGFloat = {
        return backgroundStartAngle
    }()
    
    private lazy var fillEndAngle: CGFloat = {
        return arcLengthPerPercentage * (percentage * 100) + backgroundStartAngle
    }()
    
    private lazy var angleDifference: CGFloat = {
        return 2 * .pi - backgroundStartAngle + backgroundEndAngle
    }()
    
    private lazy var arcLengthPerPercentage: CGFloat = {
       return angleDifference / 100
    }()
   

    // MARK: Paths and shapes
    
    private lazy var backgroundPath: UIBezierPath = {
        let path = UIBezierPath(arcCenter: arcCenter,
                                radius: radius/2 - arcWidth/2,
                                startAngle: backgroundStartAngle,
                                endAngle: backgroundEndAngle,
                                clockwise: true)
        path.lineWidth = arcWidth
        backgroundShapeColor.setStroke()
        path.lineCapStyle = .round
        return path
    }()
    
    private lazy var fillPath: UIBezierPath = {
        let path = UIBezierPath(arcCenter: arcCenter,
                                 radius: (radius - (arcWidth - fillArcWidth))/2 - fillArcWidth/2,
                                 startAngle: fillStartAngle,
                                 endAngle: fillEndAngle,
                                 clockwise: true)
        path.lineWidth = fillArcWidth
        return path
    }()
    
    private lazy var gradientLayer: CAGradientLayer = {
        let gradient = CAGradientLayer()
        gradient.frame = bounds
        gradient.startPoint = CGPoint(x: 0, y: 1)
        gradient.endPoint = CGPoint(x: 1, y: 1)
        gradient.colors = [gradientStartColor.cgColor, gradientMiddleColor.cgColor, gradientEndColor.cgColor]
        return gradient
    }()
    
    private lazy var maskShape: CAShapeLayer = {
        let maskShape = CAShapeLayer()
        maskShape.frame = bounds
        maskShape.lineWidth = fillArcWidth
        maskShape.strokeColor = UIColor.red.cgColor
        maskShape.fillColor = UIColor.clear.cgColor
        maskShape.lineCap = kCALineCapRound
        maskShape.path = fillPath.cgPath
        return maskShape
    }()
    
    // MARK: Animations
    
    private lazy var drawAnimation: CABasicAnimation = {
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        animation.fromValue = 0
        animation.toValue = 1
        animation.duration = 1
        return animation
    }()
    
}
