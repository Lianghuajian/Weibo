//
//  UserDefaultHeaderView.swift
//  新浪微博
//
//  Created by 梁华建 on 2019/7/12.
//  Copyright © 2019 梁华建. All rights reserved.
//

import UIKit
private let margin = 10
class UserHeadView: UIView {
    //MARK: - UI赋值
    var statusViewModel : StatusViewModel?
    {
        didSet
        {
            guard let um = statusViewModel?.status.user else {
                return
            }
            iconImageView.sd_setImage(with:URL.init(string:  um.profile_image_url!), completed: nil)
            nameLabel.text = um.screen_name
            followLabel.text = String.init(format: "Follow %@",  um.friends_count.toNumString)
            followerLabel.text = String.init(format: "Follower %@", um.followers_count.toNumString)
            verifiedLabel.text = String.init(format:"%@",um.description_c ?? "")
            
        }
    }
   
    //MARK: - 生命周期
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - 初始化控件和布局视图
    func setUpUI() {
        
        //1.添加控件
        self.addSubview(bgImageView)
        bgImageView.addSubview(iconImageView)
        bgImageView.addSubview(nameLabel)
        bgImageView.addSubview(followLabel)
        bgImageView.addSubview(sepView)
        bgImageView.addSubview(followerLabel)
        bgImageView.addSubview(verifiedLabel)
        
        //2.自定义布局
        bgImageView.snp.makeConstraints { (make) in
            make.top.equalTo(self.snp.top)
            make.left.equalTo(self.snp.left)
            make.height.equalTo(screenHeight*0.377)
            make.width.equalTo(screenWidth)
        }
        
        iconImageView.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.bgImageView.snp.centerX)
            make.centerY.equalTo(self.bgImageView.snp.centerY).offset(-margin)
            make.width.equalTo(screenWidth*0.15)
            make.height.equalTo(screenWidth*0.15)
        }
        
        nameLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.iconImageView.snp.centerX)
            make.top.equalTo(self.iconImageView.snp.bottom).offset(margin)
        }
        
        sepView.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.nameLabel.snp.centerX)
            make.top.equalTo(self.nameLabel.snp.bottom).offset(margin)
            make.width.equalTo(1)
            make.height.equalTo(16)
        }
        
        followLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.sepView.snp.top)
            make.right.equalTo(self.sepView.snp.left).offset(-margin)
        }
        
        followerLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.sepView.snp.top)
            make.left.equalTo(self.sepView.snp.right).offset(10)
        }
        verifiedLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.followLabel.snp.bottom).offset(margin)
            make.centerX.equalTo(sepView.snp.centerX)
        }
        
        //3.设置控件
        iconImageView.layer.cornerRadius = screenWidth*0.075
        
        iconImageView.layer.masksToBounds = true
        
    }
    
    //MARK: - 成员变量
    //占屏幕高度比例0.377
    lazy var bgImageView: UIImageView = {
        let bgImageView = UIImageView.init()
        bgImageView.backgroundColor = .black
        return bgImageView
    }()
    
    lazy var iconImageView: UIImageView = {
        let iiv = UIImageView.init()
        iiv.backgroundColor = .black
        return iiv
    }()
    
    lazy var nameLabel : UILabel = {
        let label = UILabel.init(size: 16, content: "", color: .white, alignment: .center, lines: 0, breakMode: .byTruncatingTail)
        return label
    }()
    
    lazy var followLabel : UILabel = {
        let label = UILabel.init(size: 14, content: "", color: .white, alignment: .center, lines: 0, breakMode: .byTruncatingTail)
        return label
    }()
    
    lazy var sepView : UIView = {
        let v = UIView.init()
        v.backgroundColor = .white
        return v
    }()
    
    lazy var followerLabel : UILabel = {
        let label = UILabel.init(size: 14, content: "", color: .white, alignment: .center, lines: 0, breakMode: .byTruncatingTail)
        return label
    }()
    
    lazy var verifiedLabel : UILabel = {
        let label = UILabel.init(size: 13, content: "", color: .white, alignment: .center, lines: 0, breakMode: .byTruncatingTail)
        return label
    }()
    
}
