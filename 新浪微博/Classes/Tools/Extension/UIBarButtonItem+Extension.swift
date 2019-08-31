//
//  UIBarButtonItem+Extension.swift
//  新浪微博
//
//  Created by 梁华建 on 2019/4/11.
//  Copyright © 2019 梁华建. All rights reserved.
//

import UIKit
extension UIBarButtonItem
{
    /// 遍历构造函数：封装一个按钮进去Item，并添加按钮图片和名称
    ///
    /// - Parameters:
    ///   - imageName: 图片名称
    ///   - target: 监听者
    ///   - actionName: 动作名称
    convenience init(imageName:String,target:Any?,actionName:String?) {
     let button = UIButton.init(image: imageName, backImage: nil)
        if let target = target , let actionName = actionName{
            
            button.addTarget(target, action: Selector(actionName), for: .touchUpInside)
            
        }
        self.init(customView: button)
    }
}
