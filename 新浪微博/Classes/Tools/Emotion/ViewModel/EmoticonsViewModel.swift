//
//  EmoticonsViewModel.swift
//  表情键盘
//
//  Created by 梁华建 on 2019/4/7.
//  Copyright © 2019 梁华建. All rights reserved.
//

import UIKit
import QorumLogs
class EmoticonsViewModel {
    ///单例
    static var shared = EmoticonsViewModel()
    
    ///包的名称
    var id : String?
    
    ///包的模型
    lazy var packages = [EmoticonPackage]()
    
    private init()
    {
        //0,添加最近分组
        packages.append(EmoticonPackage(dict:["group_name_cn":"最近" as AnyObject]))
        //1,加载emoticons.plist
        let path = Bundle.main.path(forResource: "emoticons.plist", ofType: nil, inDirectory: "Emoticons.bundle")!
        //2,把plist转成字典
        let dict = NSDictionary.init(contentsOfFile: path) as! [String:AnyObject]
        //3,拿到packages下的key的数组
        let array = (dict["packages"] as! NSArray).value(forKey: "id")
        //4,加载每个包的content.plist
        (array as! [String]).forEach(){loadinfoplist(name: $0)}
        //print(packages)
    }
    
    func loadinfoplist(name:String)
    {
        //1,加载content.plist
        let path = Bundle.main.path(forResource: "content.plist", ofType: nil, inDirectory: "Emoticons.bundle/\(name)")!
        //2,plist转字典
        let dict = NSDictionary.init(contentsOfFile: path) as! [String:AnyObject]
        //3,拼接package模型
        packages.append(EmoticonPackage.init(dict: dict))
    }
    //MAKR: - 微博带表情正文
    ///把字符串转化为属性字符串
    func emoticonText(string : String  , font : UIFont) -> NSAttributedString{
        //"我[爱你]啊[笑哈哈]"
        let strM = NSMutableAttributedString(string: string)
        //1,正则表达式[]是正则表达式关键字，需要转义
        let patten = "\\[.*?\\]"
        //我们拿到[爱你]和[笑哈哈]这两个字符串
        let regex = try! NSRegularExpression.init(pattern: patten, options: [])
        
        let results = regex.matches(in: string, options: [], range: NSRange.init(location: 0   , length: string.length))
        //获得匹配数量
        var count = results.count
        //倒着遍历，否则range会被改变
        while count > 0 {
            count -= 1
//            QL1("count = \(count)")
            let range = results[count].range(at: 0)
            
            let emStr = (string as NSString).substring(with: range)
//            print("微博表情文字表情显示前: \(strM)")
            if let em = emoticonString(string: emStr)
            {
//                QL1(string)
//                QL1(range)
                //[笑哈哈]转化出attribute文字
                let attrText = EmoticonAttachment(emoticon: em).imageText(font: font)
//                QL1(attrText.length)
//                strM.replaceCharacters(in: NSRange.init(location: 0, length: 2), with: attrText)
                strM.replaceCharacters(in: range, with: attrText)
            }
        }
//        print("微博表情文字表情显示后: \(strM)")
        //重新调整一下整段字体大小
        strM.addAttribute(NSAttributedString.Key.font, value: font, range: NSRange.init(location: 0, length: strM.length))
//         表情键盘颜色 strM.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.lightGray, range: NSRange.init(location: 0, length: strM.length))
        return strM
    }
    ///根据表情包字符串，在表情包中找到对应的表情
    private func emoticonString(string : String) -> Emoticon? {
        //找到对应名字的表情模型
        for package in EmoticonsViewModel.shared.packages{
            
            let emoticon = package.emoticons.filter{$0.chs == string}.last
//            QL1("package.filter.count = \(package.emoticons.filter{$0.chs == string}.count)")
            if emoticon != nil
            {
                return emoticon
            }
        }
        return nil
        
    }
}
