//
//  UserInfo.swift
//  新浪微博
//
//  Created by 梁华建 on 2019/3/7.
//  Copyright © 2019 梁华建. All rights reserved.
//

import UIKit
//用户初模型
@objcMembers class UserAccount :NSObject,NSCoding,Codable{
    //MARK: - 属性
    ///用户令牌
    var access_token : String?
    ///用户信息码
    var uid : String?
    ///access_token距离现在的过期时间，保护用户安全,秒为单位
    //使用监听属性的话，写入时候不能起到监听作用，expiresDate就会变成nil
    var expires_in : TimeInterval = 0
    ///过期日期
    //计算性属性不能在ivar中拿到
    var expiresDate : Date?
    ///用户大头像地址
    var avatar_large : String?
    ///用户名称
    var screen_name : String?
    ///是否是真名
    var isRealName : String?
    ///用户所在t地
    var location : String?
    ///粉丝数
    var followers_count : String?
    ///关注数
    var friends_count : String?
    ///微博数
    var statuses_count : String?
    ///个人描述
    //var description : String?
    var status : Status?
    ///归档数据写入沙盒
    //    func saveToSandBox() {
    //
    //        var path = URL.init(fileURLWithPath: NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last! )
    //
    //        path = path.appendingPathComponent("account.plist")
    //
    //        print(path.absoluteString )
    //        //该解析方法已经过时
    //        //        do {
    //        //            try NSKeyedArchiver.archiveRootObject(self, toFile: path!.absoluteString)}
    //        //
    //        //        catch{
    //        //            assert(true, "无法把account写入path");
    //        //        }
    //        do {
    //            let data = try NSKeyedArchiver.archivedData(withRootObject: self, requiringSecureCoding: false)
    //            do{
    //                try data.write(to: path)
    //            }
    //            catch{
    //                assert(true, "无法把account写入path")
    //            }
    //        }catch{
    //            assert(true, "无法生成归档数据")
    //        }
    //    }
    //
    
    func getPropertyNameList() -> [String] {
        
        var count : UInt32 = 0
        
        var names : [String] = []
        
        let properties = class_copyPropertyList(type(of: self), &count)
        
        guard let propertyList = properties else {
            return []
        }
        
        for i in 0..<count{
            let property = propertyList[Int(i)]
            
            let char_b = property_getName(property)
            
            if let key = String.init(cString: char_b, encoding: String.Encoding(rawValue: String.Encoding.utf8.rawValue)) as String?{
                names.append(key)
            }
        }
        
        free(properties)
        
        return names
    }
    //MARK: - 数据持久化(归档)
    ///归档数据存储到磁盘
    func encode(with aCoder: NSCoder)  {
        
        let propertyList = getPropertyNameList()
        
        //print(propertyList)
        
        propertyList.forEach { (p_name) in
        //print("\(p_name) + \(String(describing: value(forKey: p_name)))")
            aCoder.encode(value(forKey: p_name), forKey: p_name)
        }
        
        //aCoder.encode(access_token, forKey: "access_token")
        //        aCoder.encode(expiresDate, forKey: "expiresDate")
        //        aCoder.encode(uid, forKey: "uid")
        //        aCoder.encode(screen_name, forKey: "screen_name")
        //        aCoder.encode(avatar_large, forKey: "avatar_large")
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init()
        
        let propertyList = getPropertyNameList()
        
//        print(propertyList)
        
        propertyList.forEach { (p_name) in
            let value = aDecoder.decodeObject(forKey: p_name)
//                        print("\(p_name) + \(String(describing: value))")
            setValue(value, forKey: p_name)
        }
        //access_token = aDecoder.decodeObject(forKey: "access_token") as? String
        //        expiresDate = aDecoder.decodeObject(forKey: "expiresDate") as? Date
        //        uid = aDecoder.decodeObject(forKey: "uid") as? String
        //        screen_name = aDecoder.decodeObject(forKey: "screen_name") as? String
        //        avatar_large = aDecoder.decodeObject(forKey: "avatar_large") as? String
    }
    //KVC方法
    
}

