//
//  EmoticonPackage.swift
//  表情键盘
//
//  Created by 梁华建 on 2019/4/7.
//  Copyright © 2019 梁华建. All rights reserved.
//

import UIKit

class EmoticonPackage: NSObject {
    //加载包名
    @objc var id : String?
    //表情包的名称，显示在toolbar
    @objc var group_name_cn : String?
    //所有表情包
    @objc lazy var emoticons = [Emoticon]()
    
    init(dict:[String:AnyObject])
    {
        super.init()
        
        id = dict["id"] as? String
        
        group_name_cn = dict["group_name_cn"] as? String
        
        if let array = dict["emoticons"] as? [[String:AnyObject]]
        {
           var index = 0
            
           for var d in array  {
            //如果图片是png，并且id有值，我们就拼接路径
            if let png = d["png"] as? String , id != nil
            {
                d["png"] = "emoticonImage" + "/" + png as AnyObject
            }
            
            emoticons.append(Emoticon.init(dict: d))
            
            index += 1
            
            if index == 20
            {
                
                emoticons.append(Emoticon.init(isRemoved: true))
                
                index = 0
            }
            
            }
        }
        appendEmpty()
    }
    
    func appendEmpty() {
        
        let count = emoticons.count%21
        //已经填满21个 不需要再填空白
        if emoticons.count>0 && count == 0
        {
        //默认这一页不会进来
        //表情这一页会进来，因为他每页刚好填满21个，不需要填空白
            return
        }
        //添加空白表情
        for _ in count..<20
        {
        emoticons.append(Emoticon.init(isEmpty: true))
        }
        //末尾添加删除按钮
        emoticons.append(Emoticon.init(isRemoved: true))
        
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {}
    
    override var description: String
    {
        let keys = ["id","group_name_cn","emoticons"]
        
        return dictionaryWithValues(forKeys: keys).description
    }
}
