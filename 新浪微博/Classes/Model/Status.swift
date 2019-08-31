  //
//  Status.swift
//  新浪微博
//
//  Created by 梁华建 on 2019/3/25.
//  Copyright © 2019 梁华建. All rights reserved.
//

import UIKit

class Status: Codable {
    ///微博的id，越新的id越大
     var id : Int = 0;
    ///正文
     var text : String?
    ///创建时间
     var created_at : String?
    ///来源
     var source : String?
    ///图片数组
     var pic_urls : [[String:String]]?
    ///用户的个人信息
     var user : User?
    ///转发微博
     var retweeted_status : Status?
    ///评论数
     var comments_count : Int = 0
    ///转发数
     var reposts_count : Int = 0
    ///点赞数
     var attitudes_count : Int = 0
    ///是否已经点赞
     var favorited : Bool = false
//    
//    init(dict:[String:AnyObject]) {
//        super.init()
//        setValuesForKeys(dict)
//    }
//    
//    override func setValue(_ value: Any?, forKey key: String) {
//        if key == "user"
//        {
//            if let dict = value as? [String:AnyObject]
//            {
//                user = User(dict:dict)
//            }
//            return
//        }
//        
//        if key == "retweeted_status"
//        {
//            if let dict = value as? [String:AnyObject]
//            {   //把转发微博的微博初始化,转发的微博本质也是一条微博
//                retweeted_status = Status.init(dict: dict)
//            }
//            return
//        }
//        
//        super.setValue(value, forKey: key)
//    }
//    
//    override func setValue(_ value: Any?, forUndefinedKey key: String) {}
//  
//    func encode(with aCoder: NSCoder) {
////        let propertyList = getPropertyNameList()
////
////        print(propertyList)
////
////        propertyList.forEach { (p_name) in
////            //print("\(p_name) + \(String(describing: value(forKey: p_name)))")
////            aCoder.encode(value(forKey: p_name), forKey: p_name)
////        }
//    }
//    required init?(coder aDecoder: NSCoder) {
//        super.init()
//
////        let propertyList = getPropertyNameList()
////
////        print(propertyList)
////
////        propertyList.forEach { (p_name) in
////            let value = aDecoder.decodeObject(forKey: p_name)
////            //print("\(p_name) + \(String(describing: value))")
////            setValue(value, forKey: p_name)
//        }
    
    
//    func getPropertyNameList() -> [String] {
//
//        var count : UInt32 = 0
//
//        var names : [String] = []
//
//        let properties = class_copyPropertyList(type(of: self), &count)
//
//        guard let propertyList = properties else {
//            return []
//        }
//
//        for i in 0..<count{
//            let property = propertyList[Int(i)]
//
//            let char_b = property_getName(property)
//
//            if let key = String.init(cString: char_b, encoding: String.Encoding(rawValue: String.Encoding.utf8.rawValue)) as String?{
//                names.append(key)
//            }
//        }
//        return names
//    }
//
}
