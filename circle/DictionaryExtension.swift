//
//  DictionaryExtension.swift
//  circle
//
//  Created by Animish Gadve on 4/21/16.
//  Copyright © 2016 Refresh.us. All rights reserved.
//

import UIKit

extension Dictionary {
    mutating func merge<K, V>(dict: [K: V]){
        for (k, v) in dict {
            self.updateValue(v as! Value, forKey: k as! Key)
        }
    }
}
