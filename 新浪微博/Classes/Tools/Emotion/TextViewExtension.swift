//
//  TableViewExtension.swift
//  表情键盘
//
//  Created by 梁华建 on 2019/4/10.
//  Copyright © 2019 梁华建. All rights reserved.
//

import UIKit
extension UITextView
{
    ///发送给服务器的图文混排文本
    func emoticonText() -> String
    {
        var strM = String()
        
        if let attrText = attributedText{
            
            attributedText.enumerateAttributes(in: NSRange(location: 0, length:attrText.length), options: []) { (dict, range, _) in
                
                //range是只第几个图片
                if  let attachment = dict[NSAttributedString.Key.attachment] as? EmoticonAttachment{
                    strM += attachment.emoticon.chs ?? ""
                }else{
                    let str = (attrText.string as NSString).substring(with: range)
                    strM += str
                }
            }
            
        }
        
        return strM
        
    }
    
    //MARK: - 插入表情操作
    func insertEmoticon(emoticon:Emoticon)
    {
        
        //1,点击空白表情
        if emoticon.isEmpty
        {
            return
        }
        
        //2,点击删除
        if emoticon.isRemoved
        {
            deleteBackward()
            
            return
        }
        
        //3,添加emoji
        if let emoji = emoticon.emoji
        {
            //selectedTextRange用户选中的地方，如果没有则等于直接添加表情
            let range = selectedTextRange!
            
            self.replace(range, withText: emoji)
            
            return
        }
        
        insertImageEmoticon(emoticon: emoticon)
        //主动调用代理方法，把placeHolder替换掉
        delegate?.textViewDidChange?(self)
    }
    
    ///处理插入图片表情
    func insertImageEmoticon(emoticon:Emoticon)
    {
        //1，创建个图片的属性文本
        let imageText = EmoticonAttachment(emoticon: emoticon).imageText(font: font!)
        
        //2，获得当前文本->可变文本用于拼接
        let currentText = NSMutableAttributedString(attributedString: self.attributedText)
        
        //3，在当前文本拼接上
        currentText.replaceCharacters(in: self.selectedRange, with: imageText)
        
        //4，替换属性文本以及恢复光标
        let range = self.selectedRange
        
        attributedText = currentText
        
        selectedRange = NSRange(location: range.location+1, length: 0)
        
    }
    
}
