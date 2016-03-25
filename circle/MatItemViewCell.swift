//
//  ListTableViewCell.swift
//  Yojo
//
//  Created by Animish Gadve on 1/17/16.
//  Copyright © 2016 OMFG Studios. All rights reserved.
//

import UIKit



class MatItemViewCell: UICollectionViewCell {
    
    @IBOutlet weak var radialChart: RadialChart!
    @IBOutlet weak var percentageLabel: UILabel!
    @IBOutlet weak var weightLabel: UILabel!
    @IBOutlet weak var itemName: UILabel!
    @IBOutlet weak var itemIcon: UIImageView!
    
    var cellData = MatItem() {
        didSet{
            if(cellData.itemWeightPercentage.floatValue > 100) {
                percentageLabel.text = "100+%";
            } else {
                percentageLabel.text = String(format:"%.01f", cellData.itemWeightPercentage.floatValue) + "%"
            }
            weightLabel.text = String(format:"%.01f", cellData.itemWeight.floatValue) + "oz";
            itemName.text = cellData.itemName
            if((UIImage(named: cellData.itemName)) != nil) {
                itemIcon.image = UIImage(named: cellData.itemName)
            } else {
                itemIcon.image = UIImage(named: "Default")
            }
            radialChart.initChart(cellData.itemWeight.floatValue > cellData.itemMaxWeight.floatValue ? cellData.itemMaxWeight : cellData.itemWeight, maxCount: cellData.itemMaxWeight, minValueColor: UIColor.redColor(), maxValueColor: UIColor.greenColor(), lineWidth: 7, isAnimated: true)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.cornerRadius = 5
        layer.masksToBounds = true;
        backgroundColor = UIColor.whiteColor()
    }
}
