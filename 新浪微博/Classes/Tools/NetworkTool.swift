//
//  AFNetworkTool.swift
//  新浪微博
//
//  Created by 梁华建 on 2019/3/5.
//  Copyright © 2019 梁华建. All rights reserved.
//

import Foundation
import Alamofire
import SVProgressHUD
//API:https://open.weibo.com/wiki/微博API

//网络单例
final class NetworkTool
{
    private static let AppKey = "3769036694"
    
    private static let AppSecret = "77edccfe16cda52369e833a7672033c3"
    
    private static let reDirectUrl = "https://www.baidu.com"
    
    typealias completion = (Any?,Error?)->Void
    
    static var shared = NetworkTool()
    
    private init(){
        
    }
    
    lazy var loadOAuth : URL = {
        let url = URL.init(string:  "https://api.weibo.com/oauth2/authorize?client_id=\(NetworkTool.AppKey)&redirect_uri=\(NetworkTool.reDirectUrl)")
       
        return url!
    }()
    
    lazy var reachabilityManager = Alamofire.NetworkReachabilityManager()
}

//MARK: - 获取用户信息
extension NetworkTool
{
    func loadUserInfo(uid:String,success:@escaping completion)  {
        
        var params = [String : Any]()
        
        let urlStrings = "https://api.weibo.com/2/users/show.json"
        
        params["uid"] = uid
        
        tokenRequest(RequestMethod: .get, URLString: urlStrings, parameters: params, progress: nil) { (result, error) -> (Void) in
            if error != nil{
                assert(true, "在通过access_token和uid获取用户数据的时候出现错误")
            }
            success(result, nil)
         }
    }
}

//MARK: - 发送API
extension NetworkTool{
    
    /// 发布微博
    ///
    /// - Parameters:
    ///   - content: 发布微博的内容，要求图文混排
    ///   - finished: 完成的回调
    /// see:
    func postStatus(content : String,image: UIImage?,finished :@escaping completion)
    {

        var params = [String : Any]()
        
        params["status"] = content
        
        if image == nil {
            let url = "https://api.weibo.com/2/statuses/update"
            
            tokenRequest(RequestMethod: .post, URLString: url, parameters: params, progress: nil) { (response, error) in
                finished(response,error)
            }
        }else{
            let url = "https://api.weibo.com/2/statuses/upload"
            
            let data = image!.pngData()!
            //name注意是图片名称
            upload(URLString: url, data: data, name: "pic", parameters: params, progress: nil, finished: finished)
        }
        
    }
}

//MARK: - 加载API
extension NetworkTool{
    
    /// 加载微博数据
    /// - Parameter since_id:若指定此参数，下拉的话返回since_id大于原来数据最新的数据，默认是0
    /// - Parameter max_id:若指定此参数，上拉的话返回max_id小于等于原来数据最新的数据,默认是0
    /// - Parameter finished: 成功与否
    /// - [查看接口返回key详情](https://open.weibo.com/wiki/2/statuses/home_timeline)
    func loadStatus(since_id : Int , max_id : Int,finished:@escaping completion){
        
        var params = [String : Any]()
        
        if since_id != 0 {
            
            params["since_id"] = since_id
            
        }
        else if
            max_id != 0{
            //防止获得一样的数据,微博提供的接口是返回小于或等于的数据
            params["max_id"] = max_id-1
        }
        
        let urlStrings = "https://api.weibo.com/2/statuses/home_timeline.json"
        
        tokenRequest(RequestMethod: .get, URLString: urlStrings, parameters: params, progress: nil, finished: finished)
    }
    //https://api.weibo.com/2/statuses/show.json
    func loadAStatus(statusID:Int,finished:@escaping completion)
    {
        var params = [String : Any]()
        
        if statusID != 0
        {
            params["id"] = statusID
        }
        
        let urlString = "https://api.weibo.com/2/statuses/show.json"
        
        tokenRequest(RequestMethod: .get, URLString: urlString, parameters: params, progress: nil, finished: finished)
    }
    
}

//MARK: - 微博评论相关

extension NetworkTool
{
    ///加载一条微博评论 https://open.weibo.com/wiki/2/comments/show
    /// 加载一条微博评论
    ///
    /// - Parameters:
    ///   - id: 微博id
    ///   - finished: 返回闭包
    func loadComments(statusID id : Int,finished:@escaping completion) {
        
        var params = [String : Any]()
        let url = "https://api.weibo.com/2/comments/show.json"
        if id != 0
        {
            params["id"] = id
        }
        
        tokenRequest(RequestMethod: .get, URLString: url, parameters: params, progress: nil, finished: finished)
        
    }
    ///评论一条微博 https://open.weibo.com/wiki/2/comments/create
    /// 评论一条微博
    ///
    /// - Parameters:
    ///   - id: 微博id
    ///   - comment: 内容
    ///   - finished: 返回闭包
    func postAComments(statusID id : Int,comment : String,finished:@escaping completion){
        
        let url = "https://api.weibo.com/2/comments/create.json"
        
        var params = [String:Any]()
        
        if id != 0
        {
            params["id"] = id
        }
        
        params["comment"] = comment
        
        tokenRequest(RequestMethod: .post, URLString: url, parameters: params, progress: nil, finished: finished)
        
    }
}

//MARK: - 获取accesst_token
extension NetworkTool
{
    func loadTokenAccess(code : String , success : @escaping completion)
    {

        let paras = ["client_id":NetworkTool.AppKey,
                     "client_secret":NetworkTool.AppSecret,
                     "grant_type":"authorization_code",
                     "code":code,
                     "redirect_uri":NetworkTool.reDirectUrl]
        
        request(RequestMethod: .post, URLString: "https://api.weibo.com/oauth2/access_token", parameters: paras, progress: nil, finished: success)
    }
}
//todo:用于直接拼接token到协议头，没有成功
//微博API的解释
//使用OAuth2.0调用API接口有两种方式：
//1、 直接使用参数，传递参数名为 access_token
//URL
//1
//https://api.weibo.com/2/statuses/public_timeline.json?access_token=abcd
//2、在header里传递，形式为在header里添加 Authorization:OAuth2空格abcd，这里的abcd假定为Access Token的值，其它接口参数正常传递即可。
class TokenAdapter: RequestAdapter {
    func adapt(_ urlRequest: URLRequest) throws -> URLRequest {
        var request = urlRequest
        
        guard let token = UserAccountViewModel.shared.accessToken else {
            return request
        }
      request.setValue(token, forHTTPHeaderField: "Authorization:OAuth2 ")

        return request
    }
}
//MARK: - 封装AFNetwork请求方法
extension NetworkTool{
    /// Token网络请求，请求微博相关数据直接使用该方法，里面已经封装好token
    ///
    /// - Parameters:
    ///   - RequestMethod: GET/POST
    ///   - URLString: 请求的URL地址
    ///   - parameters: POST的参数
    ///   - progress: 请求过程补抓
    ///   - success: 成功回调
    func tokenRequest(RequestMethod : HTTPMethod,URLString : String, parameters : [String : Any]? , progress :((Progress)->Void)? , finished : @escaping (completion)){
        
        var paras = parameters

        if !appendToken(parameters: &paras){
            finished(nil,NSError(domain: "cn.itcast.error", code: -1001, userInfo: ["message":"token为空"]))
        }
        request(RequestMethod: RequestMethod, URLString: URLString, parameters: paras, progress: progress, finished: finished)
    }
    ///从用户模型中拿到token并拼接到parameters中
    func appendToken(parameters :inout [String:Any]?) -> Bool {
        
        guard let token = UserAccountViewModel.shared.accessToken else {
            return false
        }
        
        if parameters == nil
        {
            parameters = [String : Any]()
        }
        
        parameters!["access_token"] = token
        
        return true
    }
    /// 网络请求
    ///
    /// - Parameters:
    ///   - RequestMethod: GET/POST
    ///   - URLString: 请求的URL地址
    ///   - parameters: POST的参数
    ///   - progress: 请求过程补抓
    ///   - success: 成功回调
     func request(RequestMethod : HTTPMethod,URLString : String, parameters :  [ String : Any]? , progress :((Progress)->Void)? , finished : @escaping (completion)){
        if !NetworkTool.hasNetwork() {
            SVProgressHUD.showInfo(withStatus: "没有网络请求失败")
            finished(nil,nil)
            return
        }
        //iOS电池栏网络加载小圆圈
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
            SessionManager.default.request(URLString, method: RequestMethod, parameters: parameters).responseJSON { (response) in
                print("本次请求的RRT：",response.timeline.description)
             UIApplication.shared.isNetworkActivityIndicatorVisible = false
            if response.error != nil{
               finished(nil,response.error!)
                return
            }
            if response.result.isFailure{
                finished(nil,response.error!)
                return
            }
            //获得反序列化后的Json数据(字典数组)
            finished(response.result.value,response.error)
            
        }
        
    }
    
    func upload(URLString : String, data: Data ,name : String, parameters : [ String : Any]? , progress :((Progress)->Void)? , finished : @escaping (completion))
    {
         var para = parameters
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        if !appendToken(parameters: &para)
        {
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            finished(nil,NSError(domain: "cn.itcast.error", code: -1001, userInfo: ["message":"token为空"]))
        }
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            //告诉服务器二进制流类型
            multipartFormData.append(data, withName: "xxx", mimeType: "application/octet-stream")
            //我们还需要拼接para到url上 如下
            if let parameters = parameters{
                for (k,v) in parameters
                {
                    let str = v as! String
                    let strData = str.data(using: .utf8)!
                    multipartFormData.append(strData, withName: k)
                }
            }
        }, to: URLString) {  encodingResult in
            switch encodingResult {
            case .success(let upload, _, _):
                upload.responseJSON { response in
                    debugPrint(response)
                }
            case .failure(let encodingError):
                print(encodingError)
            }
            }
        }
}

//MARK: - 获取网络状态
extension NetworkTool
{
    static func hasNetwork() -> Bool{
        guard let rm = shared.reachabilityManager  else {
            return false
        }
    return rm.isReachable
    }
    static func usingWiFi() -> Bool{
        guard let rm = shared.reachabilityManager  else {
            return false
        }
        return rm.isReachableOnEthernetOrWiFi
    }
    static func usingWWAN() -> Bool{
        guard let rm = shared.reachabilityManager  else {
            return false
        }
        return rm.isReachableOnWWAN
    }
}
