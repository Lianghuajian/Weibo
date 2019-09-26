//
//  StatusTopView.swift
//  新浪微博
//
//  Created by 梁华建 on 2019/3/25.
//  Copyright © 2019 梁华建. All rights reserved.
//

import UIKit
import SnapKit
import QorumLogs

protocol ClickTopViewProtocol : NSObjectProtocol {
    func clickClickTopView(statusTopView:StatusTopView)
    func clickCloseButton(statusTopView:StatusTopView)
}

class StatusTopView: UIView {
    
    weak var clickdelegate : ClickTopViewProtocol?
    
    //MARK: - 生命周期
    var viewModel : StatusViewModel?{
        didSet{
            nameLabel.text = viewModel?.status.user?.screen_name
            //           QL1(viewModel?.status.created_at!)
            sourceLabel.text = viewModel?.source
            //           QL1("来源：\(viewModel?.source)")
            timeLabel.text = viewModel?.created_at
            iconView.sd_setImage(with: viewModel?.profileURL, placeholderImage: viewModel?.defaultProfile, options: [], completed: nil)
            memberIconView.image = viewModel?.memberImage
            vipIconView.image = viewModel?.verifiedImage
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame:frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK: - 成员变量
    ///用户头像
    private lazy var iconView : UIImageView = UIImageView.init(image: UIImage.init(named: "avatar_default"))
    ///用户名称
    private lazy var nameLabel : UILabel = UILabel.init(content: "梁华建",color: .gray, size: screenHeight*0.0246)
    ///会员图标 大
    private lazy var memberIconView : UIImageView = UIImageView.init(image:UIImage.init(named: "common_icon_membership_level1"))
    ///认证图标 小
    private lazy var vipIconView : UIImageView = UIImageView.init(image: UIImage.init(named: "avatar_vip"))
    ///时间标签
    private lazy var timeLabel : UILabel = UILabel.init(content:""
        ,color: .gray , size:screenHeight*0.02)
    ///来源标签
    private lazy var sourceLabel : UILabel = UILabel.init(content: "来源",color: .gray, size: screenHeight*0.02)
    
    private lazy var closeButton : UIButton = UIButton.init(text: "x", textColor: .gray, backImage: nil, highlight: nil, textSize: screenHeight*0.0246, isBack: false, backgroundColor: .white)
}
//MAKR: - 布局视图
extension StatusTopView
{
    
    func setupUI(){
        
        //1,添加子控件
        let sepView = UIView()
        sepView.backgroundColor = UIColor.init(red: 238.0/255.0, green: 238.0/255.0, blue: 238.0/255.0, alpha: 1)
        self.addSubview(sepView)
        self.addSubview(iconView)
        self.addSubview(nameLabel)
        self.addSubview(memberIconView)
        self.addSubview(vipIconView)
        self.addSubview(timeLabel)
        self.addSubview(sourceLabel)
        self.addSubview(closeButton)
        //2.布局
        sepView.snp.makeConstraints { (make) in
            make.top.equalTo(self.snp.top)
            make.left.equalTo(self.snp.left)
            make.right.equalTo(self.snp.right)
            make.height.equalTo(StatusCellMargins)
        }
        
        iconView.snp.makeConstraints { (make) in
        make.top.equalTo(sepView.snp.bottom).offset(StatusCellMargins)
            make.left.equalTo(self.snp.left).offset(StatusCellMargins)
            make.height.equalTo(CellIconWidth)
            make.width.equalTo(CellIconWidth)
        }
        
        nameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(iconView.snp.right).offset(StatusCellMargins)
            make.top.equalTo(iconView.snp.top)
        }
        
        memberIconView.snp.makeConstraints { (make) in
            make.left.equalTo(nameLabel.snp.right).offset(StatusCellMargins)
            make.top.equalTo(iconView.snp.top)
        }
        
        vipIconView.snp.makeConstraints { (make) in
            make.centerX.equalTo(iconView.snp.right)
            make.centerY.equalTo(iconView.snp.bottom)
        }
        
        timeLabel.snp.makeConstraints { (make) in
            make.bottom.equalTo(iconView.snp.bottom)
            make.left.equalTo(iconView.snp.right).offset(StatusCellMargins)
        }
        
        sourceLabel.snp.makeConstraints { (make) in
            make.bottom.equalTo(iconView.snp.bottom)
            make.left.equalTo(timeLabel.snp.right).offset(StatusCellMargins)
        }
        closeButton.snp.makeConstraints { (make) in
            make.right.equalTo(self.snp.right).offset(-StatusCellMargins)
            make.top.equalTo(sepView.snp.bottom).offset(StatusCellMargins)
            make.height.equalTo(44)
        }
        closeButton.addTarget(self, action: #selector(clickCloseButton(sender:)), for: .touchUpInside)
        //3.添加手势
        let tapGesture = UITapGestureRecognizer.init(target: self, action: #selector(clickTopView))
        self.addGestureRecognizer(tapGesture)
    }
    @objc func clickCloseButton(sender: UIButton)
    {
        clickdelegate?.clickCloseButton(statusTopView:self)
    }
    @objc func clickTopView(){
        clickdelegate?.clickClickTopView(statusTopView: self)
    }
}
