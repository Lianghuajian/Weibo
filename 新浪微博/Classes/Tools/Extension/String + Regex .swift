//
//  GeneralString + Extension.swift
//  新浪微博
//
//  Created by 梁华建 on 2019/4/27.
//  Copyright © 2019 梁华建. All rights reserved.
//

import UIKit
extension String{
    //MARK: - 微博时间
    ///过滤出微博来源数据 正则式:<a href=\"(.*?)\" .*?>(.*?)</a>
    var sourceString:(link:String , text:String)?{
        let str = self
        let patten = "<a href=\"(.*?)\" .*?>(.*?)</a>"
        let regex = try! NSRegularExpression.init(pattern: patten, options:[])
        guard let result = regex.firstMatch(in: str, options: [], range: NSRange.init(location: 0, length: str.count)) else{
            //print("没有匹配到字符串")
            return nil
        }
        
        let link = (str as NSString).substring(with: result.range(at: 1))
        
        let text = (str as NSString).substring(with: result.range(at: 2))
        
        return (link,text)
    }
}

