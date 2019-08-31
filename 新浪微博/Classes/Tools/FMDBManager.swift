//
//  FMDBTool.swift
//  FMDB使用
//
//  Created by 梁华建 on 2019/4/20.
//  Copyright © 2019 梁华建. All rights reserved.
//

import UIKit
//我们做了桥接，框架已经内嵌与swift，可以直接在任何文件中使用
//import FMDB
let tableName = "status.db"

class FMDBManager: NSObject {
    //请不要多线程使用该对象
    static let shared = FMDBManager()
    
    var DBqueue : FMDatabaseQueue?
    //MARK: - 打开数据库
    private override init(){
        super.init()
        var path = URL.init(string: NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last!)
        
        path?.appendPathComponent(tableName)
//        print(path?.absoluteString)
        //如果不存在该数据库，队列会帮我们创建一个。
        DBqueue = FMDatabaseQueue.init(path: path!.absoluteString)
        
        CreateTable()
        
    }
    
    //MARK: - 创建表格
    func CreateTable(){
        
        let path = URL.init(fileURLWithPath: Bundle.main.path(forResource: "db.sql", ofType: nil, inDirectory: nil)!)
        
        let sql = try! String.init(contentsOf: path)
        
        DBqueue?.inDatabase({ (db) in
        if !db.tableExists("T_Status")
        {
        db.executeUpdate(sql, withArgumentsIn: [])
        }
        })
        
    }
    //MARK: - 查询数据
    func SearchRecord(sql : String) -> [[String : Any]]? {
        //let sql = "SELECT id , name , age , height FROM T_Person;"
        var array : [[String : Any]]? = [[String : Any]]()
        //由于该线程是同步线程，不需要返回闭包
        FMDBManager.shared.DBqueue?.inDatabase({ (db) in
            
            guard let rs = try? db.executeQuery(sql, values: nil) else{
                
                print("查询数据出错")
                array = nil
                return
            }
            
            while rs.next(){
                let colCount = rs.columnCount
                var dict = [String : Any]()
                //注意这里从0开始
                for col in 0..<colCount
                {
                    let name = rs.columnName(for: col)
                    let value = rs.object(forColumnIndex: col)
                    dict[name!] = value
                }
                array!.append(dict)
            }
        })
        return array
    }
}
