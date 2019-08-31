//
//  DateExtension.swift
//  新浪微博
//
//  Created by 梁华建 on 2019/4/26.
//  Copyright © 2019 梁华建. All rights reserved.
//

import Foundation

extension Date
{
    static var getCurrentTime : String{
        let date = Date()
        
        let timeFormatter = DateFormatter()
        
        timeFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
        
        let strNowTime = timeFormatter.string(from: date)
        
        return strNowTime
    }
    
    ///根据新浪微博提供的日期，生成相应的date对象
    static func sinaDate (dateString:String) -> Date?{
        
        let df = DateFormatter()
        
        df.locale = Locale.init(identifier: "en")
        
        df.dateFormat = "EEE MMM dd HH:mm:ss zzz yyyy"
        
        return df.date(from: dateString)
    }
    ///打印出相对的新浪微博时间
    var dateDescription : String {
        
        let calendar = Calendar.current
        //今天的日期
        if calendar.isDateInToday(self){
            //let a = Date.timeIntervalSince(self)
            let delta = -self.timeIntervalSinceNow
            
            if delta < 60 {
                return "刚刚"
            }
            if delta < 3600 {
                return "\(Int(delta/60))分钟前"
            }
            return "\(Int(delta/3600))小时前"
        }
        //非今天的日期
        var fmt = " HH:mm"
        if calendar.isDateInYesterday(self) {
            fmt = "昨天" + fmt
        }else{
            fmt = "MM-dd" + fmt
            //看看是不是上年的微博
            let comps = calendar.component(.year, from: self)
            if comps > 0{
                fmt = "yyyy-" + fmt
            }
         }
        
        let df = DateFormatter()
        df.locale = Locale.init(identifier: "en")
        df.dateFormat = fmt
        
        return df.string(from: self)
    }
    
}
