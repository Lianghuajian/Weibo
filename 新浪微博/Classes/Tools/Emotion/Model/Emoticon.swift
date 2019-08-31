//
//  Emoticon.swift
//  表情键盘
//
//  Created by 梁华建 on 2019/4/7.
//  Copyright © 2019 梁华建. All rights reserved.
//

import UIKit

class Emoticon: NSObject
{
    ///发送给服务器的表情字符串
    @objc var chs: String?
    ///在本地显示的图片名称
    @objc var png: String?
    ///emoji的字符串编码
    @objc var code:String?
        {
        didSet{
            emoji = code?.emoji
        }
    }
    ///emoji的字符串
    var emoji : String?
    ///表情地址
    var imagePath : String{
        
        if png == nil
        {
            return ""
        }
        
        return Bundle.main.bundlePath + "/Emoticons.bundle/" + png!
    }
    ///是否删除按钮标记
    var isRemoved :Bool = false
    ///是否为空
    var isEmpty :Bool = false
    ///点击次数
    var times : Int = 0
    
    //MARK: - 构造函数
    ///创建一个空白cell,补充不同类别的表情组
    init(isEmpty:Bool) {
        self.isEmpty = isEmpty
    }
    
    ///创建一个空白cell
    ///当我们需要添加删除按钮的时候，我们只需要初始化他是一个空白的cell就可以了,不用做其他初始化操作
    init(isRemoved : Bool) {
        self.isRemoved = isRemoved
    }
    
    init(dict:[String:AnyObject])
    {
        
        super.init()
        
        setValuesForKeys(dict)
        
    }
    override func setValue(_ value: Any?, forUndefinedKey key: String) {}
    
    override var description: String
    {
        let keys = ["chs","png","code"]
        
        return dictionaryWithValues(forKeys: keys).description
    }
}
