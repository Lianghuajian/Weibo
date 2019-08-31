
//
//  String.swift
//  表情键盘
//
//  Created by 梁华建 on 2019/4/7.
//  Copyright © 2019 梁华建. All rights reserved.
//

import Foundation

extension String{
    ///通过传入的Unicode码自动打印表情
    var emoji : String {
        let scanner = Scanner.init(string: self)
        var value = UInt32.zero
        scanner.scanHexInt32(&value)
        return String(Character.init(UnicodeScalar(value)!))
    }
}
