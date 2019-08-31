//
//  InfoTableViewCell.swift
//  新浪微博
//
//  Created by 梁华建 on 2019/6/13.
//  Copyright © 2019 梁华建. All rights reserved.
//

import UIKit
/*
 *第二行cell
 */

class InfoTableViewCell: UITableViewCell {
    let cellHeight = screenHeight*0.093
    let cellMargin = screenHeight*0.093*0.18
    var viewModel : UserAccountViewModel?
    {
        didSet
        {
            if viewModel!.account!.statuses_count != nil{
                weiboCountLabel.text = String(viewModel!.account!.statuses_count!)
            }
            if viewModel!.account!.friends_count != nil{
                followCountLabel.text = String(viewModel!.account!.friends_count!)
            }
            if viewModel!.account!.followers_count != nil{
            followerCountLabel.text = String(viewModel!.account!.followers_count!)
            }
        }
    }
    //MARK: - 生命周期
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    //MARK: - 视图布局
    func setUpUI() {
        //0,设置cell
        self.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: screenWidth)
        self.selectionStyle = .none
        //1,添加控件
        self.addSubview(weiboCountLabel)
        self.addSubview(followCountLabel)
        self.addSubview(followerCountLabel)
        self.addSubview(weiboLabel)
        self.addSubview(followerLabel)
        self.addSubview(followLabel)
        //2,添加约束
        weiboCountLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(screenWidth/6)
            make.top.equalTo(cellMargin)
            
        }
        followCountLabel.snp.makeConstraints { (make) in
             make.centerX.equalTo(screenWidth/2)
             make.top.equalTo(cellMargin)
        }
        followerCountLabel.snp.makeConstraints { (make) in
             make.centerX.equalTo(screenWidth*5/6)
             make.top.equalTo(cellMargin)
        }
        weiboLabel.snp.makeConstraints { (make) in
             make.centerX.equalTo(screenWidth/6)
             make.bottom.equalTo(self.contentView.snp_bottom).offset(-cellMargin)
        }
        followLabel.snp.makeConstraints { (make) in
             make.centerX.equalTo(screenWidth/2)
            make.bottom.equalTo(self.contentView.snp_bottom).offset(-cellMargin)
        }
        followerLabel.snp.makeConstraints { (make) in
             make.centerX.equalTo(screenWidth*5/6)
            make.bottom.equalTo(self.contentView.snp_bottom).offset(-cellMargin)
        }
        
    }

    //MARK: - 懒加载属性
    lazy var weiboCountLabel : UILabel = {
       let label = UILabel.init(size: 16, content: "6", color: UIColor.init(red: 53.0/255.0, green: 53.0/255.0, blue: 53.0/255.0, alpha: 1), alignment: .center, lines: 0, breakMode: .byTruncatingTail)
        return label
    }()
    lazy var followCountLabel : UILabel = {
        let label = UILabel.init(size: 13, content: "104", color: UIColor.init(red: 53.0/255.0, green: 53.0/255.0, blue: 53.0/255.0, alpha: 1), alignment: .center, lines: 0, breakMode: .byTruncatingTail)
        return label
    }()
    lazy var followerCountLabel : UILabel = {
        let label = UILabel.init(size: 16, content: "8", color: UIColor.init(red: 53.0/255.0, green: 53.0/255.0, blue: 53.0/255.0, alpha: 1), alignment: .center, lines: 0, breakMode: .byTruncatingTail)
        return label
    }()
    lazy var weiboLabel : UILabel = {
        let label = UILabel.init(size: 13, content: "Weibo", color:UIColor.init(red: 163.0/255.0, green: 163.0/255.0, blue: 163.0/255.0, alpha: 1) , alignment: .center, lines: 1, breakMode: .byTruncatingTail)
        return label
    }()
    lazy var followLabel : UILabel = {
        let label = UILabel.init(size: 13, content: "Follow", color:UIColor.init(red: 163.0/255.0, green: 163.0/255.0, blue: 163.0/255.0, alpha: 1) , alignment: .center, lines: 1, breakMode: .byTruncatingTail)
        return label
    }()
    lazy var followerLabel : UILabel = {
        let label = UILabel.init(size: 14, content: "Follower", color:UIColor.init(red: 163.0/255.0, green: 163.0/255.0, blue: 163.0/255.0, alpha: 1) , alignment: .center, lines: 1, breakMode: .byTruncatingTail)
        return label
    }()
}
