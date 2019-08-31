//
//  CommentModel.swift
//  新浪微博
//
//  Created by 梁华建 on 2019/7/9.
//  Copyright © 2019 梁华建. All rights reserved.
//

import UIKit

//返回值字段    字段类型    字段说明
//created_at    string    评论创建时间
//id    int64    评论的ID
//text    string    评论的内容
//source    string    评论的来源
//user    object    评论作者的用户信息字段 详细
//mid    string    评论的MID
//idstr    string    字符串型的评论ID
//status    object    评论的微博信息字段 详细
//reply_comment    object  评论来源评论，当评论为评论他人评论的时候
class CommentModel: Codable {
     var created_at : String?
     var id : Int = 0
     var text : String?
     var source : String?
     var user : User?
     var reply_comment : CommentModel?
    
    convenience init(dict : [String : AnyObject]?){
        self.init()
//        setValuesForKeys(dict)
    }
    
//    override func setValue(_ value: Any?, forKey key: String) {
//        if key == "user"
//        {
//            if let dict = value as? [String:AnyObject]
//            {
//                user = User(dict:dict)
//            }
//            return
//        }
//        if key == "reply_comment"
//        {
//            
//            if let dict = value as? [String : AnyObject]
//            {
//                reply_comment = CommentModel.init(dict: dict)
//            }
//                return
//        }
//        super.setValue(value, forKey: key)
//    }
//    
//    override func setValue(_ value: Any?, forUndefinedKey key: String) {
//        
//    }
}
