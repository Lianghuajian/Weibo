//
//  CGSize + Extension.swift
//  新浪微博
//
//  Created by 梁华建 on 2019/10/17.
//  Copyright © 2019 梁华建. All rights reserved.
//

import UIKit

extension CGSize : Comparable
{
    public static func < (lhs: CGSize, rhs: CGSize) -> Bool {
        return (lhs.width < lhs.width) && (lhs.height < lhs.height)
    }
    
    public static func <= (lhs: CGSize, rhs: CGSize) -> Bool {
        return lhs < rhs || (lhs.width == lhs.width && lhs.height == lhs.height)
    }

    public static func * (lhs: CGSize, rhs: CGFloat) -> CGSize
    {
        
        return CGSize(width: lhs.width * rhs, height: lhs.height * rhs)
    }
}

//extension CGPoint : Comparable
//{
//    public static func < (lhs: CGPoint, rhs: CGPoint) -> Bool {
//           return (lhs.x < lhs.x) && (lhs.y < lhs.y)
//       }
//       
//       public static func <= (lhs: CGPoint, rhs: CGPoint) -> Bool {
//           return lhs < rhs || (lhs.x == lhs.x && lhs.y == lhs.y)
//       }
//
//}
