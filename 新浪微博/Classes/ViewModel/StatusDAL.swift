//
//  StatusDAL.swift
//  新浪微博
//
//  Created by 梁华建 on 2019/4/22.
//  Copyright © 2019 梁华建. All rights reserved.
//

import UIKit
//import 
class StatusDAL {
    //七天一清
    static let maxExpiredTime : TimeInterval = 7*24*60*60
    //MARK: - 定期清理内存
    ///定期清理内存
    class func clearMemoryAWeekBefore(){
    let date = Date.init(timeIntervalSinceNow: -maxExpiredTime )
    let format = DateFormatter()
        //获得当地时区
        format.locale = Locale.init(identifier: "en")
        format.dateFormat = "yyyy-MM-dd HH:mm:ss"
    let dataStr = format.string(from: date)
        print(dataStr)
    let sql = "DELETE FROM T_Status WHERE createtime < ?"
        FMDBManager.shared.DBqueue?.inDatabase({ (db) in
            do {
                try db.executeUpdate(sql, values: [dataStr])
                print("删除了\(db.changes)条数据")
            }
            catch{
                print("删除数据出错")
            }
        })
    }
    
    //MARK: - 数据加载(本地->网络)
    ///数据加载(本地->网络)
    class func loadStatus(since_id: Int, max_id: Int,finished:@escaping (([[String:Any]]?)->Void)){
        var array : [[String : Any]]!
        
        // 0,判断是否有网络
        if !NetworkTool.hasNetwork()
        {
            // 1,判断本地是否有缓存
            array = loadFromDatabase(since_id: since_id, max_id: max_id)
            // 2,有的话从本地加载并返回字典数组
            if array != nil  {
                print("使用了数据库数据")
                finished(array!)
                return
            }else
            {
                finished(nil)
            }
        }
        else
        {
        // 3,从网络加载
        NetworkTool.shared.loadStatus(since_id: since_id, max_id: max_id)
        { (result, error) in
            if error != nil
            {
                finished(nil)
                assert(true, "加载错误")
            }
            //1,拿到statuses键下的字典
            guard let result = result as? [String:AnyObject], let statuses = result["statuses"] as? [[String:AnyObject]] else
            {
                finished(nil)
                assert(true, "数据格式错误")
                return
            }
            
            array = statuses
            // 4,缓存网络加载内容到本地
            cacheFromInternet(array: array!)
            // 5,返回网络加载内容
            finished(array!)
        }
        }
    }
    ///从本地加载数据
    private class func loadFromDatabase(since_id: Int, max_id: Int) -> [[String:Any]]?{
        
        guard let userId = UserAccountViewModel.shared.account?.uid else{
            print("用户没登录无法拿到数据库内容")
            return nil
        }
        var sql = "SELECT statusId,status,userId FROM T_Status WHERE userId == \(userId) "
        
        if since_id > 0 {
            //下拉刷新
            sql.append(contentsOf: "AND statusId > \(since_id) " )
        }else if max_id > 0{
            //上拉刷新
            sql.append(contentsOf: "AND statusId < \(max_id) ")
        }
        
        sql.append(contentsOf: "ORDER BY statusId DESC LIMIT 20")
        
        //print("查询sql是 ->"+sql)
        //获取查询后的数据集
        guard let array = FMDBManager.shared.searchRecord(sql: sql) , array.count > 0 else{
            return nil
        }
        var result = [[String:Any]]()
        for dict in array{
            let json = dict["status"] as! Data
            //反序列化，把data数据转化成json
            let status = try! JSONSerialization.jsonObject(with: json, options: []) as! [String:Any]
            result.append(status)
        }
//        print(result)
        return result
    }

    ///缓存网络数据到本地
    private class func cacheFromInternet(array : [[String:Any]]){
        //0,获得用户id
        guard let userId = UserAccountViewModel.shared.account?.uid else{
            print("用户没登录无法拿到数据库内容")
            return
        }
        print(String.init(format: "写入%i条微博进数据库", array.count))
        //1,准备SQL
        //SQLITE特殊语法INSERT OR REPLACE,当获得相同id的微博就进行替换
    //由于我们每次刷新都会获得20条数据，可能刷新后没有获得新的数据，而是获得原来的数据，那么这时候我们要替换了,可能点赞数和评论数出现了不同
        let sql = "INSERT OR REPLACE INTO T_Status (statusId,status,userId) VALUES (?,?,?)"
        //2,存入数据库
        FMDBManager.shared.DBqueue?.inTransaction({ (db, rollBack) in
            do{
                for dict in array{
                    //AFN已经帮我们进行了是否可以json序列化的判断了
                    /*
                     For example, a JSON response serializer may check for an acceptable status code (`2XX` range) and content type (`application/json`), decoding a valid JSON response into an object.可以解析成对象才会返回给我们*/
                    let status = try JSONSerialization.data(withJSONObject: dict, options: [])
                    
                    try db.executeUpdate(
                        sql, values: [dict["id"]!,status,userId])
                }
            }catch{
                //补抓到错误进行数据库rollBack
                rollBack.pointee = true
                
            }
        })
    }
}
