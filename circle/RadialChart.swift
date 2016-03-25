//
//  RadialChart.swift
//  circle
//
//  Created by Animish Gadve on 2/17/16.
//  Copyright © 2016 Refresh.us. All rights reserved.
//

import UIKit

class RadialChart:UIView {
    
    var _currentCount = NSNumber()
    var _maxCount = NSNumber()
    var _minValueColor = UIColor()
    var _maxValueColor = UIColor()
    var _lineWidth = NSNumber()
    var _isAnimated = Bool()
    
    var circle = CAShapeLayer()
    var circleBackground = CAShapeLayer()
    var gradient = CAShapeLayer()
    var percentageLabel = UILabel()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = superview?.backgroundColor
    }
    
    func initChart(currentCount:NSNumber, maxCount:NSNumber, minValueColor:UIColor, maxValueColor:UIColor, lineWidth:NSNumber, isAnimated:Bool) {
        
        _currentCount = currentCount
        _maxCount = maxCount
        _minValueColor = minValueColor
        _maxValueColor = maxValueColor
        _lineWidth = lineWidth
        _isAnimated = isAnimated
        
        let startAngle = -90.0
        let endAngle = 270.0
        
        
        let circlePath = UIBezierPath(arcCenter: CGPointMake(bounds.width/2, bounds.height/2),
                                         radius: bounds.height/2 - CGFloat(_lineWidth.floatValue/2),
                                     startAngle: CGFloat(startAngle/180 * M_PI),
                                       endAngle: CGFloat(endAngle/180 * M_PI),
                                      clockwise: true)
        
        circle.path = circlePath.CGPath
        circle.lineCap = kCALineCapRound
        circle.lineWidth = CGFloat(_lineWidth)
        circle.fillColor = UIColor.clearColor().CGColor
        circle.zPosition = 1
        
        circleBackground.path = circlePath.CGPath
        circleBackground.lineCap = kCALineCapRound
        circleBackground.lineWidth = CGFloat(_lineWidth)
        circleBackground.fillColor = UIColor.clearColor().CGColor
        circleBackground.zPosition = -1
        circleBackground.strokeEnd = 1
        
        percentageLabel.frame = CGRect.init(x: 0, y: 0, width: 100, height: 100)
        percentageLabel.textAlignment = NSTextAlignment.Center
        percentageLabel.font = UIFont.systemFontOfSize(30)
        percentageLabel.textColor = UIColor.whiteColor()
        percentageLabel.center = CGPoint.init(x: bounds.width/2, y: bounds.height/2)
        
        layer.addSublayer(circleBackground)
        layer.addSublayer(circle)
//        addSubview(percentageLabel)
        
        strokeChart()
    }
    
    func strokeChart() {
        let countPercentage = _currentCount.floatValue / _maxCount.floatValue * 100
        if(countPercentage <= 33) {
            circle.strokeColor = _minValueColor.CGColor
        } else if (countPercentage <= 67) {
            circle.strokeColor = UIColor.yellowColor().CGColor
        } else if (countPercentage <= 100) {
            circle.strokeColor = _maxValueColor.CGColor
        }
        circle.strokeEnd =  CGFloat(_currentCount.floatValue) / CGFloat(_maxCount.floatValue)
        percentageLabel.text = String(format:"%.0f",countPercentage) + "%"
        

        
//        // Add gradient
//        gradient.fillColor = UIColor.clearColor().CGColor
//        gradient.strokeColor = UIColor.blackColor().CGColor
//        gradient.lineWidth = circle.lineWidth
//        gradient.lineCap = kCALineCapRound
//        gradient.frame =  CGRectMake(0, 0, 2 * bounds.size.width, 2 * bounds.size.height);
//        gradient.path = circle.path;
//        
//        let gradientLayer = CAGradientLayer(layer: layer)
//        gradientLayer.startPoint = CGPointMake(0.5,1.0);
//        gradientLayer.endPoint = CGPointMake(0.5,0.0);
//        gradientLayer.frame = CGRectMake(0, 0, 2 * bounds.size.width, 2 * bounds.size.height);
//       
//        var colors = [AnyObject]()
//        colors += [_maxValueColor.CGColor as AnyObject, _minValueColor.CGColor as AnyObject]
//        
//        gradientLayer.colors = colors;
//        gradientLayer.mask = gradient
//        circle.addSublayer(gradient)
//        gradient.strokeEnd = CGFloat(_currentCount.floatValue / _maxCount.floatValue)
        
        if(_isAnimated) {
            animateIfNeeded()
        }
    }
    
    func animateIfNeeded() {
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.duration = 2
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        animation.fromValue = 0
        animation.toValue = _currentCount.floatValue / _maxCount.floatValue
        circle.addAnimation(animation, forKey: "strokeEndAnimation")
    }
    
}