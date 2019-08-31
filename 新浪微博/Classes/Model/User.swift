//
//  user.swift
//  新浪微博
//
//  Created by 梁华建 on 2019/3/25.
//  Copyright © 2019 梁华建. All rights reserved.
//

import UIKit

/// - [查看接口返回key详情](https://open.weibo.com/wiki/2/users/show)
class User: Codable {
    ///用户UID
     var id : Int = 0
    ///用户昵称
     var screen_name : String?
    ///用户头像地址
     var profile_image_url : String?
    ///认证类型 -1：没有认证 0：认证用户 2，3，4：企业用户 220：达人
     var verified_type : Int = 0
    ///会员等级 0-6
     var mbrank : Int = 0
    
     var description_c : String?
    
     var followers_count : Int = 0
    
     var friends_count : Int = 0
    
     var status : Status?
   
}
