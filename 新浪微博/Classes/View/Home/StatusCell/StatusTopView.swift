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
    func clickClickTopView(viewModel:StatusViewModel)
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
    //MARK: - 懒加载控件
    ///用户头像
    private lazy var iconView : UIImageView = UIImageView.init(image: UIImage.init(named: "avatar_default"))
    ///用户名称
    private lazy var nameLabel : UILabel = UILabel.init(content: "梁华建",color: .gray, size: 14)
    ///会员图标 大
    private lazy var memberIconView : UIImageView = UIImageView.init(image:UIImage.init(named: "common_icon_membership_level1"))
    ///认证图标 小
    private lazy var vipIconView : UIImageView = UIImageView.init(image: UIImage.init(named: "avatar_vip"))
    ///时间标签
    private lazy var timeLabel : UILabel = UILabel.init(content:""
        ,color: .gray , size:11)
    ///来源标签
    private lazy var sourceLabel : UILabel = UILabel.init(content: "来源",color: .gray, size: 11)
    
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
        
        //3.添加手势
        let tabGesture1 = UITapGestureRecognizer.init(target: self, action: #selector(clickTopView))
        let tabGesture2 = UITapGestureRecognizer.init(target: self, action: #selector(clickTopView))
        let tabGesture3 = UITapGestureRecognizer.init(target: self, action: #selector(clickTopView))
        let tabGesture4 = UITapGestureRecognizer.init(target: self, action: #selector(clickTopView))
        let tabGesture5 = UITapGestureRecognizer.init(target: self, action: #selector(clickTopView))
        let tabGesture6 = UITapGestureRecognizer.init(target: self, action: #selector(clickTopView))
        //    tabGesture.
        iconView.addGestureRecognizer(tabGesture1)
        nameLabel.addGestureRecognizer(tabGesture2)
        memberIconView.addGestureRecognizer(tabGesture3)
        sourceLabel.addGestureRecognizer(tabGesture4)
        vipIconView.addGestureRecognizer(tabGesture5)
        timeLabel.addGestureRecognizer(tabGesture6)
        iconView.isUserInteractionEnabled = true
        nameLabel.isUserInteractionEnabled = true
        memberIconView.isUserInteractionEnabled = true
        sourceLabel.isUserInteractionEnabled = true
        vipIconView.isUserInteractionEnabled = true
        timeLabel.isUserInteractionEnabled = true
    }
    
    @objc func clickTopView(){
        clickdelegate?.clickClickTopView(viewModel: self.viewModel!)
    }
}
