//
//  MatVisualizerViewCell.swift
//  circle
//
//  Created by Animish Gadve on 6/15/16.
//  Copyright © 2016 Refresh.us. All rights reserved.
//

import UIKit

class MatVisualizerViewCell: UICollectionViewCell {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.cornerRadius = 5
        layer.masksToBounds = true;
        backgroundColor = UIColor.whiteColor()
    }
    
    func drawItems(list:Array<Array<MatItem>>) {
        for sectionList:Array<MatItem> in list {
            for item:MatItem in sectionList {
                if (item.itemId != 0) {
                    let circlePath = UIBezierPath(arcCenter: CGPoint(x: CGFloat(Double(item.xCoord) * 3),y: CGFloat(Double(item.yCoord) * 1.5)), radius: calculateRadius(item.itemWeightPercentage), startAngle: CGFloat(0), endAngle:CGFloat(M_PI * 2), clockwise: true)
                    
                    let shapeLayer = CAShapeLayer()
                    shapeLayer.path = circlePath.CGPath
                    
                    //change the fill color
                    shapeLayer.fillColor = UIColor.greenColor().CGColor
                    //you can change the stroke color
                    shapeLayer.strokeColor = UIColor.redColor().CGColor
                    //you can change the line width
                    shapeLayer.lineWidth = 3.0
                    
                    self.layer.addSublayer(shapeLayer)
                }
            }
        }
    }
    
    func calculateRadius(itemPercentage:NSNumber) -> CGFloat {
        return CGFloat(Double(itemPercentage) * 0.2)
    }
}
