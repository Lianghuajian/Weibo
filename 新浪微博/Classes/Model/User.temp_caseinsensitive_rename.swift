//
//  user.swift
//  新浪微博
//
//  Created by 梁华建 on 2019/3/25.
//  Copyright © 2019 梁华建. All rights reserved.
//

import UIKit

class User: NSObject {
    ///用户UID
    @objc var id : Int = 0
    ///用户昵称
    @objc var screen_name : String?
    ///用户头像地址
    @objc var profile_image_url : String?
    ///认证类型 -1：没有认证 0：认证用户 2，3，4：企业用户 220：达人
    @objc var verified_type : Int = 0
    ///会员等级 0-6
    @objc var mbrank:Int = 0
    
    init(dict:[String:AnyObject]) {
        super.init()
        setValuesForKeys(dict)
    }
    override func setValue(_ value: Any?, forUndefinedKey key: String) {}
}
