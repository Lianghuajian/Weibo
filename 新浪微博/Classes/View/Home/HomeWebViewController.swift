
//
//  HomeWebViewController.swift
//  新浪微博
//
//  Created by 梁华建 on 2019/4/29.
//  Copyright © 2019 梁华建. All rights reserved.
//

import UIKit
import WebKit
class HomeWebViewController: UIViewController {
    
    //MARK: - 成员变量
    lazy var webView : WKWebView = WKWebView()
    
    private var progressView : UIProgressView = {
        let proView = UIProgressView.init(frame: CGRect.init(x: 0, y: 44-2, width: UIScreen.main.bounds.width, height: 2))
        proView.trackTintColor = .white
        proView.progressTintColor = .orange
        return proView
    }()

    var url : URL
    //MARK: - 生命周期
    init(url:URL) {
        self.url = url
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.main.async {
            self.prepareWebView()
        }
        // Do any additional setup after loading the view.
    }
    func prepareWebView()
    {
        self.view.addSubview(webView)
        webView.snp.makeConstraints { (make) in
            make.left.equalTo(self.view.snp.left)
            make.top.equalTo(self.view.snp.top)
            make.width.equalTo(self.view.bounds.size.width)
            make.height.equalTo(self.view.bounds.size.height)
        }
        webView.navigationDelegate = self
        webView.load(URLRequest.init(url: url))
        webView.addObserver(self, forKeyPath: "estimatedProgress", options: NSKeyValueObservingOptions.new, context: nil)
        //加进度条
        self.navigationController?.navigationBar.addSubview(progressView)
    }
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        guard let keyPath = keyPath else {
            return
        }
        
        if keyPath == "estimatedProgress"
        {
            progressView.setProgress(Float(webView.estimatedProgress), animated: true)
            progressView.isHidden = progressView.progress == 1
        }
    }
    
    deinit {
        self.progressView.removeFromSuperview()
        webView.removeObserver(self, forKeyPath:"estimatedProgress")
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
}

//webViewDelegate
extension HomeWebViewController : WKNavigationDelegate
{
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
          webView.evaluateJavaScript("document.title", completionHandler: { (data, error) in
            self.navigationItem.title = data as? String
        })
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
       guard let url = navigationAction.request.url else
       {
        return
        }
        let app = UIApplication.shared
        if url.absoluteString.contains("itunes.apple.com") {
            if (app.canOpenURL(url))
            {
                app.open(url, options:[:], completionHandler: nil)
            }
            //取消跳转，打开appStore
            decisionHandler(WKNavigationActionPolicy.cancel)
            return
        }
        
        decisionHandler(.allow)
        
    }
}
