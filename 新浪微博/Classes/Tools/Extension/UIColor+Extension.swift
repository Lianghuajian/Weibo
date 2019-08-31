//
//  UIColor+Extension.swift
//  新浪微博
//
//  Created by 梁华建 on 2019/4/13.
//  Copyright © 2019 梁华建. All rights reserved.
//

import UIKit

extension UIColor {
    
    class var randomColor : UIColor{
        return UIColor.init(red: CGFloat(arc4random()%256)/255.0, green: CGFloat(arc4random()%256)/255.0, blue: CGFloat(arc4random()%256)/255.0, alpha: 1)
    }
    
}
