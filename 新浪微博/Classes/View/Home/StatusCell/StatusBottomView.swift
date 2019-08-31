//
//  StatusBottomView.swift
//  新浪微博
//
//  Created by 梁华建 on 2019/3/25.
//  Copyright © 2019 梁华建. All rights reserved.
//

import UIKit
import QorumLogs
protocol StatusBottomViewClickDelegate : NSObjectProtocol {
    func commentButtonClick(pointToWindows:CGPoint)
    func retweetButtonClick(pointToWindows:CGPoint)
    func likeButtonClick(pointToWindows:CGPoint)
}
class StatusBottomView: UIView {
    //MARK: - 生命周期
    override init(frame: CGRect) {
        super.init(frame:frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - 成员属性
    weak var delegate : StatusBottomViewClickDelegate?
    
    var viewModel : StatusViewModel?{
        didSet
        {
            let reports_count =  viewModel!.status.reposts_count
            
            if reports_count != 0
            {
                retweetedButton.setTitle(" "+String(reports_count), for: .normal)
            }else
            {
                 retweetedButton.setTitle("", for: .normal)
            }
            
            let comments_count = viewModel!.status.comments_count
            
            if comments_count != 0
            {
                commentButton.setTitle(" "+String(comments_count), for: .normal)
            }else
            {
                 commentButton.setTitle("", for: .normal)
            }
            
            let attitudes_count =  viewModel!.status.attitudes_count
            
            if attitudes_count != 0
            {
                likeButton.setTitle(" "+String(attitudes_count), for: .normal)
            }else
            {
                likeButton.setTitle("", for: .normal)
            }
        }
    }
    ///转发按钮
    private lazy var retweetedButton = UIButton.init(text: " 转发", textColor: UIColor.darkGray, backImage: "timeline_icon_retweet", textSize: 12,isBack:false);
    ///评论按钮
    private lazy var commentButton = UIButton.init(text: " 评论", textColor: UIColor.darkGray, backImage: "timeline_icon_comment", textSize: 12,isBack:false);
    ///点赞按钮
    private lazy var likeButton = UIButton.init(text: " 点赞", textColor: UIColor.darkGray, backImage: "timeline_icon_unlike", textSize: 12,isBack:false);
    
}
extension StatusBottomView {
    func setupUI()
    {
        //1.添加控件
        self.addSubview(retweetedButton)
        self.addSubview(commentButton)
        self.addSubview(likeButton)
        let line1 = sepLine()
        let line2 = sepLine()
        self.addSubview(line1)
        self.addSubview(line2)
        let w = 0.5
        let scale = 0.4
        
        //2.添加约束
        retweetedButton.snp.makeConstraints { (make) in
            make.top.equalTo(self.snp.top)
            make.left.equalTo(self.snp.left)
            make.bottom.equalTo(self.snp.bottom)
        }
        
        commentButton.snp.makeConstraints { (make) in
            make.top.equalTo(retweetedButton.snp.top)
            make.left.equalTo(retweetedButton.snp.right)
            make.width.equalTo(retweetedButton.snp.width)
            make.height.equalTo(retweetedButton.snp.height)
        }
        
        likeButton.snp.makeConstraints { (make) in
            make.top.equalTo(commentButton.snp.top)
            make.left.equalTo(commentButton.snp.right)
            make.width.equalTo(commentButton.snp.width)
            make.height.equalTo(commentButton.snp.height)
            make.right.equalTo(self.snp.right)
        }
        
        line1.snp.makeConstraints { (make) in
            make.height.equalTo(retweetedButton.snp.height).multipliedBy(scale)
            make.width.equalTo(w)
            make.left.equalTo(retweetedButton.snp.right)
            make.centerY.equalTo(retweetedButton.snp.centerY)
            
        }
        line2.snp.makeConstraints { (make) in
            make.height.equalTo(commentButton.snp.height).multipliedBy(scale)
            make.width.equalTo(w)
            make.left.equalTo(commentButton.snp.right)
            make.centerY.equalTo(retweetedButton.snp.centerY)
        }
        
        //3.设置监听
        commentButton.addTarget(self, action: #selector(commentClicked), for: .touchUpInside)
    }
    @objc func commentClicked(){
        
      let point = self.convert(CGPoint.init(x: 0, y: self.frame.size.height), to: UIApplication.shared.keyWindow)
        delegate?.commentButtonClick(pointToWindows: point)
        
    }
    //分割线
    func sepLine() -> UIView{
        let line = UIView()
        line.backgroundColor = UIColor.gray
        return line
    }
}
