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
    @IBInspectable var textColor: UIColor = .darkGray
    
    var value: String?
    var unitName: String?
    
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
        addSubview(valueLabel)
        addSubview(unitLabel)
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
    
    
    // MARK: Labels

    private lazy var valueLabelWidth: CGFloat = { return radius/2 }()
    private lazy var valueLabelHeight: CGFloat = { return valueLabelFont.lineHeight }()
    private lazy var unitLabelWidth: CGFloat = { return radius/2 }()
    private lazy var unitLabelHeight: CGFloat = { return unitLabelFont.lineHeight }()
    private let valueLabelFont: UIFont = .monospacedDigitSystemFont(ofSize: 70, weight: .black)
    private let unitLabelFont: UIFont = .systemFont(ofSize: 17)
    
    private lazy var valueLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: bounds.midX - valueLabelWidth/2, y: arcCenter.y - valueLabelHeight + unitLabelHeight, width: valueLabelWidth, height: valueLabelHeight))
        if let value = value {
            label.text = value
        }
        label.textColor = textColor
        label.textAlignment = .center
        label.font = valueLabelFont
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 2 / label.font.pointSize
        return label
    }()
    
    private lazy var unitLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: bounds.midX - unitLabelWidth/2, y: arcCenter.y + unitLabelHeight, width: unitLabelWidth, height: unitLabelHeight))
        if let unitName = unitName {
            label.text = unitName
        }
        label.textColor = textColor
        label.textAlignment = .center
        label.font = unitLabelFont
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 2 / label.font.pointSize
        return label
    }()
    
}
