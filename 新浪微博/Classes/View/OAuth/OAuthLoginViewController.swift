//
//  OAuthLoginViewController.swift
//  新浪微博
//
//  Created by 梁华建 on 2019/3/6.
//  Copyright © 2019 梁华建. All rights reserved.
//

import UIKit
import SVProgressHUD
import WebKit
class OAuthLoginViewController: UIViewController {
    ///加载WebView界面
    lazy var webView = WKWebView()
    
    override func loadView() {
        view = webView
        title = "登录新浪微博"
        navigationItem.leftBarButtonItem = UIBarButtonItem.init(title: "关闭", style: .plain, target: self, action: #selector(Close))
        navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "自动填充", style: .plain, target: self, action: #selector(AutoFill))
        webView.navigationDelegate = self
    }
    ///关闭页面
    @objc func Close(){
        SVProgressHUD.dismiss()
        navigationController?.popViewController(animated: true)

    }
    
    ///自动填充
    @objc func AutoFill()
    {
        
    let js = "document.getElementById('userId').value = '13113771561';document.getElementById('passwd').value = 'Jb153297'"
        
      webView.evaluateJavaScript(js)
   
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DispatchQueue.main.async {
            self.setWebView()
        }
    }
    
    func setWebView() {
        
        webView.frame = UIScreen.main.bounds
        
        webView.load(URLRequest.init(url: NetworkTool.shared.loadOAuth))
        
    }
    
}
//MARK: - WKNavigationDelegate方法
extension OAuthLoginViewController : WKNavigationDelegate
{
    //拦截webView跳转界面(baidu)
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        
        guard let url = navigationResponse.response.url else{
            print("GetCanceld")
            decisionHandler(.cancel)
            return
        }
        guard let host = url.host , host == "www.baidu.com" else{
    
            decisionHandler(.allow)
            return
        }
        
        guard let query = url.query , query.hasPrefix("code=") else{
            //取消授权
            self.Close()
            decisionHandler(.cancel)
            return
        }
        
        //授权码获取
        let code = query.substring(fromIndex: "code=".count)
        
        UserAccountViewModel.shared.loadAccessToken(code: code) { (isSuccess) in
            if isSuccess{
                //停止指示器 否则不会被销毁
                SVProgressHUD.dismiss();
                    NotificationCenter.default.post(name: NSNotification.Name.init(rawValue: WBSwitchVCControllerNotification), object: nil)

            }else{
                
                SVProgressHUD.showInfo(withStatus: "你的网络不给力")
                
                DispatchQueue.main.asyncAfter(deadline: .now()+1, execute: {
                    self.Close()
                })
            }
        }
        
        decisionHandler(.cancel)
        
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        SVProgressHUD.dismiss()
    }
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        SVProgressHUD.show()
    }
}

