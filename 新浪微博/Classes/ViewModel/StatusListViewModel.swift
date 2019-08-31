//
//  StatusViewModel.swift
//  新浪微博
//
//  Created by 梁华建 on 2019/3/25.
//  Copyright © 2019 梁华建. All rights reserved.
//

import UIKit
import SDWebImage
import Alamofire

class StatusListViewModel
{
    ///StatusViewModel的数组
    var statusList = [StatusViewModel]()
    
    //下拉刷新得到的数据
    var pullDownStatusCount : Int?
}
//MARK :-封装网络获取发布的动态
extension StatusListViewModel{
    func loadStatus(isPullUp : Bool,finished:@escaping (_ isSuccess : Bool) -> Void)
    {
        //获得第一条数据的since_id 如果是下拉
        let since_id = isPullUp ? 0 : (statusList.first?.status.id ?? 0)
        //获得最后一条数据的max_id 如果是上拉
        let max_id = isPullUp ? (statusList.last?.status.id ?? 0) : 0
        
        StatusDAL.loadStatus(since_id: since_id, max_id: max_id) { (statuses) in
            
            guard let statuses = statuses else
            {
                finished(false)
                return
            }
            
            
            let decoder = JSONDecoder()
            //2,Json -> StatusViewModel
            let list = statuses.compactMap({ (jsonDict) -> StatusViewModel? in
                //先把每个statusJson字典转化成Data类型
                //通过data去写模型
                 do {
                    let d = try JSONSerialization.data(withJSONObject:
                    jsonDict, options: [])
                    //Json -> StatusModel
                    let status = try decoder.decode(Status.self, from: d)
                    return StatusViewModel.init(status: status)
                }catch
                {
                    return nil
                }
            })
            //赋值下拉刷新到的数据，用于显示刷新条数
            if since_id > 0
            {
                self.pullDownStatusCount = statuses.count
            }
            //3,赋值StatusList,刷新的数据直接拼接
            if isPullUp {
                //上拉获得旧的数据 尾部拼接
                self.statusList += list
            }else{
                //下拉获得新的数据 头部拼接
                self.statusList = list + self.statusList
            }
            //print("刷新了\(List.count)条微博 ，总微博为\(self.StatusList.count)")
            //4,我们要保证finish闭包要在缓存完单图后
            self.cacheSinglePic(StatusList: list,finished: finished)
        //注意：如果不再缓存结束再去调用finish闭包，这边单图的cell会出现布局错误，比如我原本的图片长度是100，这时候调用reloadData，大小被确认下来了，这时候我再剪切图片成60，由于自动布局，bottomView也跟着上去.
        //比如图片高度是90，然后我们在单图缓存完后调用图片size调整函数，我们默认的size是120，在磁盘中找到该图片时候再去更新size，如果没找到就120，这时候就会产生30的高度差。
            
        }
    }
    
    func replaceStatusIn(statusId : Int , statusViewModel : StatusViewModel)
    {
        var start = 0
        
        var end = statusList.count - 1
        
        var mid = (start + end) / 2
        
        while start <= end {
            mid = (start + end) / 2
            if statusList[mid].status.id > statusId
            {
                end = mid - 1
            }else if statusList[mid].status.id < statusId
            {
                start = mid + 1
            }else
            {
                statusList[mid] = statusViewModel
                break
            }
            
        }
        
    }
    
}

//MARK: -单图缓存
extension StatusListViewModel{
    
    /// 单图缓存
    /// 目的：把单图提前缓存起来，得到其单图的比例
    /// - Parameter StatusList: 用户微博模型列表
    func cacheSinglePic(StatusList : [StatusViewModel],finished:@escaping (_ isSuccess : Bool) -> Void){
        //计算总单图的长度
        var dataLength = 0
        //建立单图缓存组，使用组保证了图片一次性缓存（同步任务的完成），缓存结束后再去进行布局
        let group = DispatchGroup.init()
        
        //print("开始缓存")
        for status in StatusList {
            //拿到单张图片的微博，否则继续往下寻找
            if status.thumbnails?.count != 1
            {
                continue
            }
            //进组
            group.enter()
            //        print("开始缓存单图 : \($0.thumbnails![0].absoluteString)")
            //缓存
            //注意：
 //设置了retryFailed，当请求失败会重新执行该闭包内容，如果里面有某些信号量的处理，可能会引起越界，如group.leave()
//设置了refreshCached，sdWeb请求服务器下载图片的时候会把缓存图片的hash值发送给服务器做图片校验，如果一样服务器返回304，否则重新执行该闭包下载，也会引起信号量的处理
            //[SDWebImageOptions.refreshCached,SDWebImageOptions.retryFailed]
            SDWebImageManager.shared().loadImage(with: status.thumbnails![0],
                                                 options: [],
                                                 progress:nil,
                                                 completed: { (image, _, _, _, _, _) in
                                                    if let image = image ,
                                                        let data = UIImage.pngData(image)(){
                                                        dataLength += data.count
                                                    }
                                                    //出组
                                                    group.leave()
            })
        }
        
        
        group.notify(queue: DispatchQueue.main) {
            //print("缓存完成")
            print("加载的微博中单图数据长度\(dataLength/1024)")
            //print("缓存图像的地址:\(NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last!)")
            
            finished(true)
        }
    }
}
