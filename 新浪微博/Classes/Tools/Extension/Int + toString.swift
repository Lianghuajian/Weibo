//
//  Int + toString.swift
//  新浪微博
//
//  Created by 梁华建 on 2019/7/11.
//  Copyright © 2019 梁华建. All rights reserved.
//

import Foundation

extension Int
{
    public var description: String
    {
        return String(self)
    }
    
    var toNumString : String
    {
        let s = self.description
        if s.length > 4 && s.length < 7
        {
            return String.init(format: "%@W", (s as NSString).substring(with: NSRange.init(location: 3, length: 2)))
        }
        if s.length >= 7
        {
           
            return String.init(format: "%@M",  s.substring(fromIndex: 6))
        }
        return s
    }
}
