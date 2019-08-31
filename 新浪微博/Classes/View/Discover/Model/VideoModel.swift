//
//  VideoModel.swift
//  新浪微博
//
//  Created by 梁华建 on 2019/8/25.
//  Copyright © 2019 梁华建. All rights reserved.
//

import Foundation
import Alamofire

final class VideoModel : Codable {
    typealias VideoCompletion = ([VideoModel]?,Error?) -> Void
    
    var indexPath : IndexPath?
    ///视频标题
    var title : String?
    
    ///位置信息
    var location : String?
    
    ///用户昵称
    var nickname : String?
    
    ///用户头像
    var avatar_thumb : String?
    
    ///视频地址
    var video_url : String?
    
    ///视频首帧画面
    var cover_url : String?
    
    ///视频活力值
    var stats_tips : String?
    
    ///评论次数
    var comment_count : String?
    
    ///点赞次数
    var digg_count : String?
    
    ///播放次数
    var play_count : String?
    
    ///分享次数
    var share_count : String?
    
    var AuthorUid : String?
    
    var dyid : String?
    
    ///头像
    var iconIndex : String? ;
    
    class func loadVideoModel(completion : @escaping VideoCompletion) {
        let apiString = "https://api-hl.huoshan.com/hotsoon/feed/?type=video&iid=56693189339&ac=WIFI&ab_version=391711,501253,592609,662547,671134,384501,663932,612165,681210,674736,654193,557631,678843,681232,680055,637814,666872,681693,661943,681616,374104,378844,682009,665355,446763,638535,681229,299910,632485,671292,651646,598627,641184,457535,493546,677944&os_api=18&app_name=live_stream&channel=App%20Store&idfa=59E6123C-45AE-4F64-9192-FD9B0E982923&device_platform=iphone&live_sdk_version=5.4.0&vid=DD5987BE-4451-43E1-B234-68525808A52F&mccmnc=&device_type=iPhone7,1&openudid=62948e3983ef2572b9acc1b524998172d40f5f73&version_code=5.4.0&os_version=12.0&screen_width=1125&aid=1112&device_id=36177005663&req_from=feed_refresh&action=refresh&diff_stream=1&mas=00f6d48a97d7aaa909e3451f22676861b28a07d5ae901270dbe287&as=a2b5c403499e6cf3806834&ts=1546666985"
        
        guard let url = URL.init(string: apiString) else{
            return
        }
        
        Alamofire.request(url).responseJSON(completionHandler: { (response) in
            guard let dict = response.result.value as? [String : AnyObject] else
            {
                completion(nil,response.error)
                return
            }
            
            guard let array = dict["data"] as? [[String : AnyObject]] else
            {
                completion(nil,response.error)
                return
            }
            var vms = Array<VideoModel>()
            array.forEach({ (d) in
                let vm = VideoModel.init(dict: d)
                vms.append(vm)
            })
    
                completion(vms,nil)
            
        })
        
    }
    
    convenience init( dict : [String : AnyObject]) {
        self.init()
        guard let data = dict["data"] as? [String : AnyObject] else {
            return
        }
        self.title = data["title"] as? String ?? ""
        guard let author = data["author"] as! [String : AnyObject]? ,let avatar_thumbs = author["avatar_thumb"] , let avatar_urls = avatar_thumbs["url_list"] as? [String] else
        {
            return
        }
        self.avatar_thumb = avatar_urls[0]
        
        self.nickname = author["nickname"] as? String
        guard let video = data["video"] as? [String : AnyObject], let cover_medium = video["cover_medium"] as? [String : AnyObject],let cover_urls = cover_medium["url_list"] as? [String] else { return  }
        self.cover_url = cover_urls[0]
        guard let video_urls = video["download_url"]  as? [String] else {
            return
        }
        self.video_url = video_urls[0]
        guard let stats = data["stats"] as? [String : AnyObject] else { return  }
        self.digg_count = String(stats["digg_count"] as! Int)
        self.comment_count = String(stats["comment_count"] as! Int)
        self.play_count = String(stats["play_count"] as! Int)
        
    }
    
}
