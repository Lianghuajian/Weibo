//
//  IconTableViewCell.swift
//  新浪微博
//
//  Created by 梁华建 on 2019/6/13.
//  Copyright © 2019 梁华建. All rights reserved.
//
/*
 *第一行cell
 */
import UIKit


/*
 *布局
 * 高度
 *分割条比例：0.1
 *头像比例：0.62
 *名字：0.173
 *个人介绍：0.115
 * 宽度
 *名字宽度：0.31
 *个人介绍：0.31
 */
class IconTableViewCell: UITableViewCell {
    let cellHeight = screenHeight*0.157
    let cellMargin = screenHeight*0.157*0.14
    //MARK: - 生命周期
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpUI()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUpUI()
    }
    //MARK: - 视图布局
    func setUpUI(){
        //0.设置cell的样式
        self.selectionStyle = .none
        //1.添加视图
        self.addSubview(spaView)
        self.addSubview(iconImageView)
        self.addSubview(nameLabel)
        self.addSubview(introductionLabel)
        self.addSubview(vipCenterLabel)
        self.addSubview(vipImageView)
        
        //2.添加布局
        spaView.snp.makeConstraints { (make) in
            make.left.equalTo(self.contentView.snp_left)
            make.top.equalTo(self.contentView.snp_top)
            make.width.equalTo(screenWidth)
            make.height.equalTo(spaHeight)
        }
        iconImageView.snp.makeConstraints { (make) in
            make.left.equalTo(self.contentView.snp_left).offset(cellMargin)
            make.top.equalTo(self.spaView.snp_bottom).offset(cellMargin)
            make.width.equalTo(cellHeight*0.62)
            make.height.equalTo(cellHeight*0.62)
        }
        
        nameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(iconImageView.snp_right).offset(cellMargin)
            make.top.equalTo(self.contentView.snp_top).offset(30)
            make.width.equalTo(screenWidth*0.31)
        }
        
        introductionLabel.snp.makeConstraints { (make) in
            make.left.equalTo(nameLabel.snp_left)
            make.top.equalTo(self.nameLabel.snp_bottom).offset(8)
            make.width.equalTo(screenWidth*0.31)
        }
        
        vipImageView.snp.makeConstraints { (make) in
        make.right.equalTo(vipCenterLabel.snp.left).offset(-10)
        make.centerY.equalTo(vipCenterLabel.snp.centerY)
        }
        
        vipCenterLabel.snp.makeConstraints({ (make) in
make.right.equalTo(self.contentView.snp_right).offset(-screenWidth*0.025)
            make.centerY.equalTo(cellHeight*0.55)
        })
    }
    
    override func setSelected(_ selected: Bool, animated: Bool)
    {
        super.setSelected(selected, animated: animated)
        
    }

    //MARK: - 懒加载属性
    var viewModel : UserAccountViewModel?{
        didSet {
            iconImageView.sd_setImage(with: viewModel?.avatar_largeURL, placeholderImage: UIImage.init(named: "avatar_default"), options: [.retryFailed,.refreshCached], completed: nil)
            
            nameLabel.text = viewModel?.account?.screen_name
        }
    }
    ///头部分割线
    lazy var spaView :UIView = {
        let view = UIView()
        view.backgroundColor = spaColor
        return view
    }()
    ///用户头像
    lazy var iconImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = cellHeight*0.31
        imageView.clipsToBounds = true
        return imageView
    }()
    
    ///用户名字
    lazy var nameLabel : UILabel = {
        let label = UILabel.init(size:cellHeight*0.173, content: "名字", color: UIColor.init(red: 53.0/255.0, green: 53.0/255.0, blue: 53.0/255.0, alpha: 1), alignment: .left, lines: 1, breakMode: .byTruncatingTail)
        return label
    }()
    
    ///用户短介绍
    lazy var introductionLabel : UILabel = {
        let label = UILabel.init(size:cellHeight*0.115, content: "Bio:No Introduction", color: UIColor.init(red: 163.0/255.0, green: 163.0/255.0, blue: 163.0/255.0, alpha: 1), alignment: .left, lines: 1, breakMode: .byTruncatingTail)
        return label
    }()
    ///vip图片
    lazy var vipImageView : UIImageView = {
        
       let iv = UIImageView.init(image: UIImage.init(named: "mine_icon_membership"))
        iv.sizeToFit()
        return iv
    }()
    ///vip文字
    lazy var vipCenterLabel : UILabel = {
       let label = UILabel.init(size: cellHeight*0.135, content: "VIP Center", color: .orange, alignment: .center, lines: 1, breakMode: .byTruncatingTail)
        var mtbAttributedText = label.attributedText!.mutableCopy() as! NSMutableAttributedString
        let attachment = NSTextAttachment.init()
        attachment.image = UIImage.init(named: "common_title_icon_arrow_yellow")
        attachment.bounds = CGRect.init(x: 0, y: 0, width: label.bounds.height, height: label.bounds.height)
mtbAttributedText.append(NSAttributedString.init(attachment: attachment))
        label.attributedText = mtbAttributedText
        
        return label
    }()
    
    
}
