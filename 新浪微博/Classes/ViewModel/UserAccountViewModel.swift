//
//  UserAccountViewModel.swift
//  新浪微博
//
//  Created by 梁华建 on 2019/3/9.
//  Copyright © 2019 梁华建. All rights reserved.
//

import Foundation

/*
 *MVVM
 *UserAccountViewModel:
 *封装业务逻辑
 *封装网络请求
 */

class UserAccountViewModel {
    
    static var shared = UserAccountViewModel()
    
    var account : UserAccount?
    ///true:已经登录登录 false:重新登录
    var userLoginStatus : Bool {
        
        return account?.access_token != nil && !isExpired
    }
    
    var accessToken : String?{
        if !isExpired {
            return account?.access_token
        }
        return nil
    }
    
     var accountPath : URL{
        let path = URL.init(fileURLWithPath: NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last!)
        return path.appendingPathComponent("account.plist")
    }
    
     var avatar_largeURL : URL? {

        if account != nil && !isExpired && account!.avatar_large != nil{
            return URL.init(string: account!.avatar_large!)!
        }
        return nil
    }
    
    private var isExpired : Bool{
        
        return account?.expiresDate?.compare(Date()) == .orderedDescending ? false : true
    }
    
    private init() {
        
        do {

            let data = try Data.init(contentsOf: accountPath)

            do{
                // NSKeyedArchiver.archivedData(withRootObject: account, requiringSecureCoding: false)与下面方法配套使用
                 account = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? UserAccount
                
                if isExpired{
                    print("access_token 过期啦")
                    account = nil
                }

            }
            catch{
                assert(true, "用户数据解档失败")
            }
        } catch {
            assert(true, "用户数据解档路径错误")
        }
        
        //过期的解档方法
     }
    
    ///更新当前用户账户
    class func upDateUserAccount(){
        UserAccountViewModel.shared = UserAccountViewModel.init()
    }
}

//MARK: - 网络请求
extension UserAccountViewModel {
    
    /// 用户登陆请求
    /// 通过Access Token加载用户数据
    /// - Parameters:
    ///   - code: 调用authorize获得的code值。
    ///   - finished: Succeed or not
    func loadAccessToken( code:String , finished: @escaping (_ isSuccess : Bool)->()){
        NetworkTool.shared.loadTokenAccess(code: code) { (data, error) in
            if error != nil{
                return
            }
            //codable方法
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .secondsSince1970
            let json = try! JSONSerialization.data(withJSONObject: data!, options: [])
            
            self.account = try! decoder.decode(UserAccount.self, from: json)
            self.account?.expiresDate = Date(timeIntervalSinceNow:self.account!.expires_in)
            self.loadUserInfo(uid: (self.account?.uid)!, finished: finished)
        }
    }
    
    func loadUserInfo(uid:String,finished : @escaping (_ isSuccess : Bool)->())  {
        NetworkTool.shared.loadUserInfo( uid: uid){ (data, error) in
            if error != nil
            {
                finished(false)
                return
            }
            
            guard let dict = data as? [String : Any] else{
                print("格式错误")
                finished(false)
                return
            }
            
            guard let account = self.account else{
                print("用户未初始化")
                finished(false)
                return
            }
            
            print(dict["location"] ?? "沙盒地址没找到")
           
            if  dict.keys.contains("error") && (dict["error"] as! String) == "User requests out of rate limit!"
            {
                print("超出一天最大请求次数")
            }
            account.screen_name = dict["screen_name"] as? String
            account.avatar_large = dict["avatar_large"] as? String
            account.location = dict["location"] as? String
            account.friends_count = String(dict["friends_count"]as! Int)
            account.followers_count = String(dict["followers_count"] as! Int)
            account.statuses_count = String(dict["statuses_count"] as! Int)
            
            do {
                guard let sdict = dict["status"] as? [String : AnyObject]else
                {
                    return
                }
                //Json -> data
                let d = try JSONSerialization.data(withJSONObject: sdict, options: []);
                self.account?.status = try JSONDecoder.init().decode(Status.self, from: d)            }catch
            {
                self.account = nil
            }
     
            do {
                let data = try NSKeyedArchiver.archivedData(withRootObject: account, requiringSecureCoding: false)
                do{
                    try data.write(to: self.accountPath)
                    print("写入数据地址====\(self.accountPath)")
                }
                catch{
                    assert(true, "无法把account写入path")
                }
            }catch{
                    assert(true, "无法生成归档数据")
            }
            finished(true)
        }
    }
}
