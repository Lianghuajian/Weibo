//
//  EmoticonAttachment.swift
//  表情键盘
//
//  Created by 梁华建 on 2019/4/10.
//  Copyright © 2019 梁华建. All rights reserved.
//

import UIKit
//把表情封装进NSTextAttachment类，获得
class EmoticonAttachment: NSTextAttachment
{
    ///表情模型
    var emoticon : Emoticon
    /// 将当前附件中emoticon转换成属性文本
    func imageText(font:UIFont) -> NSAttributedString
    {
        image = UIImage(contentsOfFile: emoticon.imagePath)
        
        //字体高度
        let lineHeight = font.lineHeight
        
        //把图片整体往下移
        bounds = CGRect.init(x: 0, y: -4, width: lineHeight, height: lineHeight)
       
        //获得图片文本
        let imageText = NSMutableAttributedString(attributedString: NSAttributedString(attachment: self))
        
        //设置该range下的imageText的字体大小
        imageText.addAttribute(NSAttributedString.Key.font, value: font , range: NSRange(location: 0, length: 1))
        
        return imageText
        
    }
   
    
    init(emoticon:Emoticon)
    {
        
        self.emoticon = emoticon
        
        super.init(data: nil, ofType: nil)
        
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        
        fatalError("init(coder:) has not been implemented")

    }

}
