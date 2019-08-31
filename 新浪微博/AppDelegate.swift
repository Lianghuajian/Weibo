//
//  AppDelegate.swift
//  新浪微博
//
//  Created by 梁华建 on 2019/3/1.
//  Copyright © 2019 梁华建. All rights reserved.
//

import UIKit
import QorumLogs

@UIApplicationMain

class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
//        FMDBManager.shared.DBqueue?.inDatabase({ (db) in
//            do{ try db.executeUpdate("DROP TABLE T_Status", values: nil)
//                print("删除T_Status成功")
//            }
//            catch{ print("删除T_Status失败")}
//        })
        QorumLogs.enabled = true
        
        setUpAppearence()
        // Override point for customization after application launch.
        window = UIWindow.init(frame: UIScreen.main.bounds)
        
        window?.backgroundColor = UIColor.white
        
        window?.rootViewController = defaultViewController
        
        window?.makeKeyAndVisible()
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: WBSwitchVCControllerNotification), object: nil, queue: nil) {
            [weak self] (notification) in
            self!.window?.rootViewController = MainViewController()
        }
        
        //埋点
        setHook()
        return true
    }

    deinit {
        NotificationCenter.default.removeObserver(self,name: NSNotification.Name(rawValue: WBSwitchVCControllerNotification), object: nil)
    }
    
    func setHook(){
        //Hook用于在HomeWebViewController停留的时间
        HomeWebViewController.initializeWithHook()
    }
    //一般全局渲染的设置都放在Appdelegate,要在控件创建前设置,否则修改无效
    func setUpAppearence() {
        
        UINavigationBar.appearance().tintColor = appearenceColor
        
        UITabBar.appearance().tintColor = appearenceColor
        
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
       
        
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
         StatusDAL.clearMemoryAWeekBefore()
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        StatusDAL.clearMemoryAWeekBefore()
    }
    
    
}
//MARK: -界面切换代码
extension AppDelegate
{
    
    var defaultViewController : UIViewController{
        if UserAccountViewModel.shared.userLoginStatus{
            return isNewVersion ? NewFeatureCollectionViewController() : WelcomeViewController()
        }
        return MainViewController()
    }
    
    var isNewVersion : Bool {
        
       let currentversion = Double( Bundle.main.infoDictionary!["CFBundleShortVersionString"] as!  String )!
        
        let oldversionkey = "sandboxVersionKey"

       let oldversion = UserDefaults.standard.double(forKey: oldversionkey)
        
        UserDefaults.standard.set(currentversion, forKey: oldversionkey)
        
        return oldversion < currentversion
    }
}
