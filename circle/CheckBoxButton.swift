//
//  CheckBoxButton.swift
//  circle
//
//  Created by Animish Gadve on 5/2/16.
//  Copyright © 2016 Refresh.us. All rights reserved.
//

import UIKit

class CheckBoxButton: UIButton {
    
    enum CheckBoxState:String {
        case CheckBoxSelected = "CheckBoxSelected"
        case CheckBoxUnselected = "CheckBoxUnselected"
    }
        
    var checkBoxState = CheckBoxState(rawValue: CheckBoxState.CheckBoxUnselected.rawValue)
    
    func setCheckBoxState(state:CheckBoxState) {
        checkBoxState = state
        setImage(UIImage(named: state.rawValue), forState: .Normal)
    }
}
