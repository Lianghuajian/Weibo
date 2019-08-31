//
//  RTHook.swift
//  新浪微博
//
//  Created by 梁华建 on 2019/5/19.
//  Copyright © 2019 梁华建. All rights reserved.
//

import UIKit

class RTHook {
    
    static func hook(className : AnyClass , from : Selector , to : Selector) {
        //被替换类的实例方法
        guard let fromMethod = class_getInstanceMethod(className,from) else{
            return
        }
        //替换类的实例方法
        guard let toMethod = class_getInstanceMethod(className,to) else {
            return
        }
        //true if the method was added successfully, otherwise false (for example, the class already contains a method implementation with that name).
        if class_addMethod(className, from, toMethod, method_getTypeEncoding(toMethod)) {
        //方法不存在，我们把to的imp变为原有方法，我们一般会在to方法中调用to方法，在交换后通过from方法中to的imp调用to方法，达到方法交换的效果,这时候to方法是from的imp，我们就依旧会调用from中的方法
            class_replaceMethod(className, to, fromMethod, method_getTypeEncoding(fromMethod))
        }else{
            //该方法已经存在我们要替换他
            method_exchangeImplementations(fromMethod, toMethod)
        }
    }
    
}
