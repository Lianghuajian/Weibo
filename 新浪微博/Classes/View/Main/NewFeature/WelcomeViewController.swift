//
//  WelcomeViewController.swift
//  新浪微博
//
//  Created by 梁华建 on 2019/3/11.
//  Copyright © 2019 梁华建. All rights reserved.
//

import UIKit
import SDWebImage
class WelcomeViewController: UIViewController {
    //MARK: -设置控件的值
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
//       print(UserAccountViewModel.shared) 
        
//        iconview.sd_setImage(with:UserAccountViewModel.shared.avatar_largeURL , placeholderImage: UIImage.init(named: "avatar_default_big"), options:.cacheMemoryOnly , completed: nil)
        //
        loadIcon()
    }
    ///磁盘加载用户头像
    func loadIcon(){
        //会先去磁盘找到该文件
        //如果没有就重新下载
    
        SDWebImageManager.shared().loadImage(with: UserAccountViewModel.shared.avatar_largeURL, options: [.refreshCached,.retryFailed], progress: nil) { (image, data, _, _, _, _) in
            guard let image = image else{
                return
            }
            DispatchQueue.main.async {
                self.iconview.image = image
            }
        }
    }
    
    //MARK: - 设置动画/键盘
    override func viewDidAppear(_ animated: Bool) {
        
        startAnimation()
        
    }
    //MARK: -设置视图结构
    override func loadView() {
        view = backimage
        setUpUI()
    }
    
    private lazy var backimage = UIImageView(image: UIImage.init(named: "ad_background"))
    
    private lazy var iconview : UIImageView = {
    
    let imv = UIImageView.init(image: UIImage.init(named: "avatar_default_big"))
    
    imv.layer.cornerRadius = 45
    
    imv.layer.masksToBounds = true
    
    return imv
        
    }()
    
    private lazy var welcomeLabel : UILabel = UILabel(content: "欢迎归来", color: .gray, size: 18)
    
    //MARK: - icon动画
    func startAnimation(){
        
        iconview.snp.updateConstraints{ (make) in
            make.bottom.equalTo(view.snp.bottom).offset(-view.bounds.height + 200 )
        }
        welcomeLabel.alpha = 0
        UIView.animate(withDuration: 1.2, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 10, options: [], animations: {
        //利用ios更新布局会进行在本次runloop事件结束后，我们提早更新重新布局的控件，达到动画的效果
            //如这里要改变他的高度，我们放慢他改变的这个动作，以及加入弹性效果。
            self.view.layoutIfNeeded()
            
        }) { (_) in
            UIView.animate(withDuration: 0.8, animations: {
                
                self.welcomeLabel.alpha = 1
                
            }){(_) in
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: WBSwitchVCControllerNotification), object: nil)
            }
        }
        
    }

}

extension WelcomeViewController{
    func setUpUI(){
        view.addSubview(iconview)
        view.addSubview(welcomeLabel)
        
        iconview.snp.makeConstraints { (make) in
            make.centerX.equalTo(view.snp.centerX)
            make.bottom.equalTo(view.snp.bottom).offset(-200)
            make.width.equalTo(90)
            make.height.equalTo(90)
        }
        welcomeLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(iconview.snp.centerX)
            make.top.equalTo(iconview.snp.bottom).offset(16)
        }
    }
}
