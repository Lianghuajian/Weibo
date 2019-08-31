//
//  String+Extension.swift
//  新浪微博
//
//  Created by 梁华建 on 2019/3/6.
//  Copyright © 2019 梁华建. All rights reserved.
//

import Foundation
extension String {
    
    var length: Int {
        return self.count
    }
    
    subscript (i: Int) -> String {
        return self[i ..< i + 1]
    }
    
    func substring(fromIndex: Int) -> String {
        return self[min(fromIndex, length) ..< length]
    }
    
    func substring(toIndex: Int) -> String {
        return self[0 ..< max(0, toIndex)]
    }
    
    subscript (r: Range<Int>) -> String {
        let range = Range(uncheckedBounds: (lower: max(0, min(length, r.lowerBound)), upper: min(length, max(0, r.upperBound))))
        let start = index(startIndex, offsetBy: range.lowerBound)
        let end = index(start, offsetBy: range.upperBound - range.lowerBound)
        return String(self[start ..< end])
    }
    
}
//不包含后几个字符串的方法
//extension String {
//    func dropLast(_ n: Int = 1) -> String {
//        return String(characters.dropLast(n))
//    }
//    var dropLast: String {
//        return dropLast()
//    }
//}
