//
//  UIViewController+Hook.swift
//  新浪微博
//
//  Created by 梁华建 on 2019/5/20.
//  Copyright © 2019 梁华建. All rights reserved.
//
import DispatchIntrospection
import UIKit
import QorumLogs
//MARK: - 对HomeWebViewController进行埋点
extension UIViewController
{
    static func initializeWithHook() {
        RTHook.hook(className: UIViewController.self, from: #selector(viewDidAppear(_:)), to: #selector(hook_viewDidAppear))
        RTHook.hook(className: UIViewController.self, from: #selector(viewDidDisappear(_:)), to: #selector(hook_viewDidDisappear))
    }
    @objc func hook_viewDidAppear(){
        //执行原有viewDidAppear
        self.hook_viewDidAppear()
        
//        print(NSStringFromClass())
//print("\(NSStringFromClass(self.classForCoder))进入时间\(Date.getCurrentTime)")
//        NSStringFromClass(self.classForCoder)
    }
    @objc func hook_viewDidDisappear(){
        
        //执行原有viewDidDisappear
        self.hook_viewDidDisappear()
//print("\(NSStringFromClass(self.classForCoder))离开时间\(Date.getCurrentTime)")
    }
}
