//
//  VisitorView.swift
//  新浪微博
//
//  Created by 梁华建 on 2019/3/4.
//  Copyright © 2019 梁华建. All rights reserved.
//

import UIKit
import SnapKit
protocol VisitorViewDelegate : NSObjectProtocol {
    //用于是controller类对子控件的响应，所以其实可以直接给button addTarget
    func ClickRegisteButton()
    
    func ClickLoginButton()
    
}

class VisitorView: UIView {
    
    weak var delegate : VisitorViewDelegate?
    
    //MARK: - 调用跳转方法
    @objc func clickRegister(){
        delegate?.ClickRegisteButton()
    }
    
    @objc func clickLogin()  {
        delegate?.ClickLoginButton()
    }
    
    //MARK: -懒加载控件
    private lazy var iconview = UIImageView.init(image: UIImage.init(named: "visitordiscover_feed_image_smallicon"))
    
    private lazy var house = UIImageView.init(image: UIImage.init(named:"visitordiscover_feed_image_house"))
    
    private lazy var maskview = UIImageView.init(image: UIImage.init(named:"visitordiscover_feed_mask_smallicon"))
    
    private lazy var messagelabel : UILabel = UILabel(content: "关注一些人，回这里看看有什么惊喜", color: .gray, size: 14)
    
    private lazy var registerButton : UIButton = UIButton.init(text: "注册", textColor: .orange, backImage: "common_button_white_disable",highlight : nil,isBack:true)
    
    private lazy var loginButton : UIButton = UIButton.init(text: "登录", textColor: .gray, backImage: "common_button_white_disable",highlight : nil,isBack:true)
    
    //MARK: - 初始化方法
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        SetUpUI()
        
    }
    
    func setUpInfo(imagename:String?,text : String?) {
        
        guard let imagename = imagename,let text = text else {
            startAnimating()
            return
        }
        
        house.image = UIImage.init(named: imagename)
        
        messagelabel.text = text
        
        iconview.isHidden = true
        
        sendSubviewToBack(maskview)
    }
    
    required init?(coder aDecoder: NSCoder) {
        //发现我们重写了init(frame:)方法，这时候就需要重写init(coder)方法
        //作用:阻止开发者再去使用XIB或StoryBoard去加载
        //XIB和SB是XML文件，所以需要Decode
        //fatalError("init(coder:) has not been implemented")
        super.init(coder: aDecoder)
        
        SetUpUI()
    }
    
    //MARK: - 布局视图
    func SetUpUI()
    {
        
        self.addSubview(iconview)
        
        self.addSubview(maskview)
        
        self.addSubview(house)
        
        self.addSubview(messagelabel)
        
        self.addSubview(registerButton)
        
        self.addSubview(loginButton)
        
        
        //遍历子控件使用自动布局,配合苹果原生开发使用
        /*
         *true :使用frame布局
         *false :使用自动布局
         */
        //        self.subviews.forEach {
        //            $0.translatesAutoresizingMaskIntoConstraints = false
        //        }
        
        //以下注释都是苹果原生开发自动添加布局
        
        //iconview自动布局 依赖VisitorView布局
        //addConstraint(NSLayoutConstraint.init(item: iconview, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1.0, constant: 0))
        //addConstraint(NSLayoutConstraint.init(item: iconview, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1.0, constant: -60))
        iconview.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.snp.centerX)
            make.centerY.equalTo(self.snp.centerY).offset(-60)
        }
        
        //house自动布局 依赖iconview布局
        //        addConstraint(NSLayoutConstraint.init(item: house, attribute: .centerX, relatedBy: .equal, toItem: iconview, attribute: .centerX, multiplier: 1.0, constant: 0))
        //        addConstraint(NSLayoutConstraint.init(item: house, attribute: .centerY, relatedBy: .equal, toItem: iconview, attribute: .centerY, multiplier: 1.0, constant: 0))
        house.snp.makeConstraints { (make) in
            make.center.equalTo(iconview.snp.center)
        }
        //messagelabel自动布局 依赖iconview布局
        //        addConstraint(NSLayoutConstraint.init(item: messagelabel, attribute: .centerX, relatedBy: .equal, toItem: iconview, attribute: .centerX, multiplier: 1.0, constant: 0))
        //        addConstraint(NSLayoutConstraint.init(item: messagelabel, attribute: .top, relatedBy:  .equal, toItem: iconview, attribute: .bottom, multiplier: 1.0, constant: 16))
        //        addConstraint(NSLayoutConstraint.init(item: messagelabel, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 36))
        //        addConstraint(NSLayoutConstraint.init(item: messagelabel, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 224))
        messagelabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(iconview.snp.centerX)
            make.top.equalTo(iconview.snp.bottom).offset(16)
            make.height.equalTo(36)
            make.width.equalTo(224)
        }
        //register按钮 依赖messagelabel
        //        addConstraint(NSLayoutConstraint.init(item: registerButton, attribute: .left, relatedBy: .equal, toItem: messagelabel, attribute: .left, multiplier: 1.0, constant: 0))
        //        addConstraint(NSLayoutConstraint.init(item: registerButton, attribute: .top, relatedBy: .equal, toItem: messagelabel, attribute: .bottom, multiplier: 1.0, constant: 16))
        //        addConstraint(NSLayoutConstraint.init(item: registerButton, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 100))
        //        addConstraint(NSLayoutConstraint.init(item: registerButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 36))
        registerButton.snp.makeConstraints { (make) in
            make.left.equalTo(messagelabel.snp.left)
            make.top.equalTo(messagelabel.snp.bottom).offset(16)
            make.width.equalTo(100)
            make.height.equalTo(36)
        }
        
        //login按钮 依赖messagelabel
        //        addConstraint(NSLayoutConstraint.init(item: loginButton, attribute: .right, relatedBy: .equal, toItem: messagelabel, attribute: .right, multiplier: 1.0, constant: 0))
        //        addConstraint(NSLayoutConstraint.init(item: loginButton, attribute: .top, relatedBy: .equal, toItem: messagelabel, attribute: .bottom, multiplier: 1.0, constant: 16))
        //        addConstraint(NSLayoutConstraint.init(item: loginButton, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 100))
        //        addConstraint(NSLayoutConstraint.init(item: loginButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 36))
        loginButton.snp.makeConstraints { (make) in
            make.right.equalTo(messagelabel.snp.right)
            make.top.equalTo(messagelabel.snp.bottom).offset(16)
            make.width.equalTo(100)
            make.height.equalTo(36)
        }
        //maskview VFL可视化语言代码
        //使用VFL可视化语言
        // H 垂直
        // V 水平
        // | 边界
        // [] 包装控件
        // views:[key,控件]
        // metrics:[key,高度]
        //        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[mask]-(Btnheight)-[register]", options: [], metrics: ["Btnheight" : -46], views: ["mask":maskview,"register":registerButton]))
        //        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[mask]-0-|", options: [], metrics: ["maskHeight" : iconview.bounds.size.height], views: ["mask":maskview]))
        
        maskview.snp.makeConstraints { (make) in
            make.left.equalTo(self.snp.left)
            make.right.equalTo(self.snp.right)
            make.top.equalTo(self.snp.top)
            make.bottom.equalTo(registerButton.snp.bottom)
        }
        
        self.backgroundColor = UIColor.init(white: 237.0/255.0, alpha: 1.0)
        
        registerButton.addTarget(self, action:#selector(clickRegister), for: .touchUpInside)
        
        loginButton.addTarget(self, action:#selector(clickLogin), for: .touchUpInside)
    }
    
    ///开启旋转动画
    func startAnimating(){
        let ca = CABasicAnimation.init(keyPath: "transform.rotation")
        
        ca.toValue = 2 * Double.pi
        
        ca.duration = 20
        
        ca.repeatCount = MAXFLOAT
        
        ca.isRemovedOnCompletion = false
        
        iconview.layer.add(ca, forKey: nil)
        
    }
}
